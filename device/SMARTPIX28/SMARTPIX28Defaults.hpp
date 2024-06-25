#ifndef DEVICE_SMARTPIX28_DEFAULTS_H
#define DEVICE_SMARTPIX28_DEFAULTS_H

#include "utils/dictionary.hpp"

namespace caribou {

  // define voltages


  // DSIPM FPGA address space
  const intptr_t DEMO_BASE_ADDRESS = 0x400000000;
  const size_t DEMO_MEM_SIZE = 0x30000;

  // define a memory map  
  const memory_map FPGA_MEM{DEMO_BASE_ADDRESS, DEMO_MEM_SIZE, PROT_READ | PROT_WRITE};


#define FPGA_REGS \
  { \
    {"sw_write32_0", {FPGA_MEM, register_t<size_t>(0x000000, 0xffffffff, true, true, false)}}, \
    {"sw_read32_0", {FPGA_MEM, register_t<size_t>(0x000004, 0xffffffff, true, true, false)}}, \
    {"sw_read32_1", {FPGA_MEM, register_t<size_t>(0x000008, 0xffffffff, true, true, false)}}, \
  }
}
#endif /* DEVICE_SMARTPIX28_DEFAULTS_H */
