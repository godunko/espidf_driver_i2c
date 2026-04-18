/*
 *  Copyright (C) 2026, Vadim Godunko
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include "driver/i2c_master.h"

int __ada_sizeof_i2c_master_bus_config_t = sizeof (i2c_master_bus_config_t);
int __ada_sizeof_i2c_device_config_t     = sizeof (i2c_device_config_t);

soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_XTAL = I2C_CLK_SRC_XTAL;
soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_RC_FAST = I2C_CLK_SRC_RC_FAST;
soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_DEFAULT = I2C_CLK_SRC_DEFAULT;

void __ada_i2c_device_config_t__initialize
   (i2c_device_config_t* Configuration,
    i2c_addr_bit_len_t   dev_addr_length,
    uint16_t             device_address,
    uint32_t             scl_speed_hz,
    uint32_t             scl_wait_us,
    bool                 disable_ack_check)
{
    Configuration->dev_addr_length = dev_addr_length;
    Configuration->device_address = device_address;
    Configuration->scl_speed_hz = scl_speed_hz;
    Configuration->scl_wait_us = scl_wait_us;
    Configuration->flags.disable_ack_check = disable_ack_check;
}

void __ada_i2c_master_bus_config_t__initialize
   (i2c_master_bus_config_t* Configuration,
    i2c_port_num_t           i2c_port,
    gpio_num_t               sda_io_num,
    gpio_num_t               scl_io_num,
    i2c_clock_source_t       clk_source,
    uint8_t                  glitch_ignore_cnt,
    int                      intr_priority,
    size_t                   trans_queue_depth,
    bool                     enable_internal_pullup,
    bool                     allow_pd)
{
    Configuration->i2c_port = i2c_port;
    Configuration->sda_io_num = sda_io_num;
    Configuration->scl_io_num = scl_io_num;
    Configuration->clk_source = clk_source;
    Configuration->glitch_ignore_cnt = glitch_ignore_cnt;
    Configuration->intr_priority = intr_priority;
    Configuration->trans_queue_depth = trans_queue_depth;
    Configuration->flags.enable_internal_pullup = enable_internal_pullup;
    Configuration->flags.allow_pd = allow_pd;
}
