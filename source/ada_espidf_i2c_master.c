/*
 *  Copyright (C) 2026, Vadim Godunko
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include "driver/i2c_master.h"

int __ada_sizeof_i2c_master_bus_config_t
  = sizeof (i2c_master_bus_config_t);

soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_XTAL = I2C_CLK_SRC_XTAL;
soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_RC_FAST = I2C_CLK_SRC_RC_FAST;
soc_periph_i2c_clk_src_t __enum_I2C_CLK_SRC_DEFAULT = I2C_CLK_SRC_DEFAULT;

void __ada_i2c_master_bus_config_t__initialize
   (i2c_master_bus_config_t* Self,
    i2c_port_num_t i2c_port,
    gpio_num_t sda_io_num,
    gpio_num_t scl_io_num,
    i2c_clock_source_t clk_source,
    uint8_t glitch_ignore_cnt,
    int intr_priority,
    size_t trans_queue_depth,
    bool enable_internal_pullup,
    bool allow_pd)
{
    Self->i2c_port = i2c_port;
    Self->sda_io_num = sda_io_num;
    Self->scl_io_num = scl_io_num;
    Self->clk_source = clk_source;
    Self->glitch_ignore_cnt = glitch_ignore_cnt;
    Self->intr_priority = intr_priority;
    Self->trans_queue_depth = trans_queue_depth;
    Self->flags.enable_internal_pullup = enable_internal_pullup;
    Self->flags.allow_pd = allow_pd;
}
