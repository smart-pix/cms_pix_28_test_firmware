/**
 * Header file for the SMARTPIX28 C++ Caribou Device
 */

#ifndef DEVICE_SMARTPIX28_H
#define DEVICE_SMARTPIX28_H

#include "device/CaribouDevice.hpp"
#include "hardware_abstraction/carboard/Carboard.hpp"

#include "SMARTPIX28Defaults.hpp"

#include <fstream>

namespace caribou {

  /** SParkDream Device class definition
   */
  class SMARTPIX28Device : public CaribouDevice<carboard::Carboard, iface_mem> {

  public:
    SMARTPIX28Device(const caribou::Configuration config);
    ~SMARTPIX28Device();

    void daqStart() override;
    void daqStop() override;

    void powerUp() override;
    void powerDown() override;
    // void setUsrclkFreq(const uint64_t freq); // included from adam
    void accessRegWrdOut(); // attempt by anthony

  };


} // namespace caribou

#endif /* DEVICE_SMARTPIX28_H */
