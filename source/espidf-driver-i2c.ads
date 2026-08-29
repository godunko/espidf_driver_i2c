--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package ESPIDF.Driver.I2C with Preelaborate is

   type i2c_port_num_t is new int;

   type i2c_addr_bit_len_t is (I2C_ADDR_BIT_LEN_7, I2C_ADDR_BIT_LEN_10)
     with Convention => C;

   type soc_periph_i2c_clk_src_t is new int;
   I2C_CLK_SRC_XTAL    : constant soc_periph_i2c_clk_src_t
     with Import, Convention => C, External_Name => "__enum_I2C_CLK_SRC_XTAL";
   I2C_CLK_SRC_RC_FAST : constant soc_periph_i2c_clk_src_t
     with Import, Convention => C, External_Name => "__enum_I2C_CLK_SRC_RC_FAST";
   I2C_CLK_SRC_DEFAULT : constant soc_periph_i2c_clk_src_t
     with Import, Convention => C, External_Name => "__enum_I2C_CLK_SRC_DEFAULT";
   --  XXX Move to Clock driver

   subtype i2c_clock_source_t is soc_periph_i2c_clk_src_t;

end ESPIDF.Driver.I2C;
