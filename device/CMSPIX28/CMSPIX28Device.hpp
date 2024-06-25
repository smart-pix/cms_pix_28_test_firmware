/**
 * Header file for the CMSPIX28 C++ Caribou Device
 */

#ifndef DEVICE_CMSPIX28_H
#define DEVICE_CMSPIX28_H

#include "device/CaribouDevice.hpp"
#include "hardware_abstraction/carboard/Carboard.hpp"

#include "CMSPIX28Defaults.hpp"

#include <fstream>

namespace caribou {

  /** SParkDream Device class definition
   */
  class CMSPIX28Device : public CaribouDevice<carboard::Carboard, iface_mem> {

  public:
    CMSPIX28Device(const caribou::Configuration config);
    ~CMSPIX28Device();

    void daqStart() override;
    void daqStop() override;

    void powerUp() override;
    void powerDown() override;
    // void setUsrclkFreq(const uint64_t freq); // included from adam
    void accessRegWrdOut(); // attempt by anthony

  };


} // namespace caribou

#endif /* DEVICE_CMSPIX28_H */
