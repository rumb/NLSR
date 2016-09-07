/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/**
 * Copyright (c) 2014-2015,  The University of Memphis,
 *                           Regents of the University of California,
 *                           Arizona Board of Regents.
 *
 * This file is part of NLSR (Named-data Link State Routing).
 * See AUTHORS.md for complete list of NLSR authors and contributors.
 *
 * NLSR is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * NLSR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * NLSR, e.g., in COPYING.md file.  If not, see <http://www.gnu.org/licenses/>.
 **/

#ifndef NLSR_HELLO_PROTOCOL_HPP
#define NLSR_HELLO_PROTOCOL_HPP

#include <boost/cstdint.hpp>
#include <ndn-cxx/face.hpp>
#include <ndn-cxx/management/nfd-control-parameters.hpp>
#include <ndn-cxx/util/scheduler.hpp>

#include <utility>
#include <ndn-cxx/util/time.hpp>
#include "logger.hpp"

namespace nlsr {

class Nlsr;

class HelloHist
{
public:
  HelloHist(ndn::Name router)
  : m_origRouter(router)
  , m_latestHelloTimePoint(ndn::time::system_clock::now())
  {
  }

  const ndn::Name
  getKey() const
  {
    ndn::Name key = m_origRouter;
    return key;
  }

  void
  updateTimePoint()
  {
    m_TimePoint = ndn::time::system_clock::now();
  }

  ndn::time::system_clock::Duration;
  getDuration()
  {
    ndn::time::system_clock::Duration duration = ndn::time::system_clock::now() - m_latestHelloTimePoint;
    return duration;
  }

private:
  ndn::Name m_origRouter;
  ndn::time::system_clock::TimePoint m_latestHelloTimePoint;
};

class HelloProtocol
{
public:
  HelloProtocol(Nlsr& nlsr, ndn::Scheduler& scheduler)
    : m_nlsr(nlsr)
    , m_scheduler(scheduler)
  {
  }

  std::list<HelloHist> m_hellohist;

  HelloHist*
  findHelloHist(const ndn::Name& key)
  {
    std::list<HelloHist>::iterator it = std::find_if(m_hellohist.begin(),
                                                   m_hellohist.end(),
                                                   bind(helloHistCompareByKey, _1, key));
    if (it != m_nameLsdb.end()) {
      return &(*it);
    }
    return 0;
  }

  bool
  addHelloHist(HelloHist& hellohist)
  {
    std::list<HelloHist>::iterator it = std::find_if(m_hellohist.begin(),
                                                  m_hellohist.end(),
                                                  bind(helloHistCompareByKey, _1,
                                                       hellohist.getKey()));
    if (it == m_hellohist.end()) {
      m_hellohist.push_back(hellohist);
      return true;
    }
    return false;
  }

  static bool
  helloHistCompareByKey(const HelloHist& hellohist, const ndn::Name& key)
  {
    return hellohist.getKey() == key;
  }

  void calDelay(ndn::Name router)
  {
    HelloHist* chkHelloHist = findHelloHist(router);
    if (chkHelloHist == 0) {
      _LOG_DEBUG("<< Add new HelloHist entry : " << router);
      addHelloHist(HelloHist(router));
    }
    else{
      _LOG_DEBUG("(EXTRACT2_MARKER),Router,"<< router << ",Delay," << chkHelloHist->getDuration());
      chkHelloHist->updateTimePoint();
    }
  }

  void
  scheduleInterest(uint32_t seconds);

  void
  expressInterest(const ndn::Name& interestNamePrefix, uint32_t seconds);

  void
  sendScheduledInterest(uint32_t seconds);

  void
  processInterest(const ndn::Name& name, const ndn::Interest& interest);

private:
  void
  processInterestTimedOut(const ndn::Interest& interest);

  void
  onContent(const ndn::Interest& interest, const ndn::Data& data);

  void
  onContentValidated(const ndn::shared_ptr<const ndn::Data>& data);

  void
  onContentValidationFailed(const ndn::shared_ptr<const ndn::Data>& data,
                            const std::string& msg);

  void
  onRegistrationFailure(uint32_t code, const std::string& error,
                        const ndn::Name& name);

  void
  onRegistrationSuccess(const ndn::nfd::ControlParameters& commandSuccessResult,
                        const ndn::Name& neighbor, const ndn::time::milliseconds& timeout);

  void
  registerPrefixes(const ndn::Name& adjName, const std::string& faceUri,
                   double linkCost, const ndn::time::milliseconds& timeout);
private:
  Nlsr& m_nlsr;
  ndn::Scheduler& m_scheduler;

  static const std::string INFO_COMPONENT;
  static const std::string NLSR_COMPONENT;
};

} //namespace nlsr

#endif // NLSR_HELLO_PROTOCOL_HPP
