--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.Driver.I2C.Master is

   ----------------------
   -- i2c_master_probe --
   ----------------------

   function i2c_master_probe
     (bus_handle   : i2c_master_bus_handle_t;
      address      : Interfaces.Unsigned_16;
      xfer_timeout : Duration) return esp_err_t
   is
      function Internal
        (bus_handle       : i2c_master_bus_handle_t;
         address          : Interfaces.Unsigned_16;
         xfer_timeout_ms  : Interfaces.C.int) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_master_probe";

      Xfer_Timeout_Ms : constant Interfaces.C.int :=
        Interfaces.C.int (xfer_timeout * 1_000);

   begin
      return Internal (bus_handle, address, Xfer_Timeout_Ms);
   end i2c_master_probe;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Self                   : out i2c_master_bus_config_t;
      i2c_port               : i2c_port_num_t        := -1;
      sda_io_num             : gpio_num_t;
      scl_io_num             : gpio_num_t;
      clk_source             : i2c_clock_source_t    := I2C_CLK_SRC_DEFAULT;
      glitch_ignore_cnt      : Interfaces.Unsigned_8 := 7;
      intr_priority          : Interfaces.C.int      := 0;
      trans_queue_depth      : Interfaces.C.size_t   := 0;
      enable_internal_pullup : Boolean               := False;
      allow_pd               : Boolean               := False)
   is
      procedure Internal
        (Self                   : out i2c_master_bus_config_t;
         i2c_port               : i2c_port_num_t;
         sda_io_num             : gpio_num_t;
         scl_io_num             : gpio_num_t;
         clk_source             : i2c_clock_source_t;
         glitch_ignore_cnt      : Interfaces.Unsigned_8;
         intr_priority          : Interfaces.C.int;
         trans_queue_depth      : Interfaces.C.size_t;
         enable_internal_pullup : Interfaces.C.C_bool;
         allow_pd               : Interfaces.C.C_bool)
         with Import,
              Convention => C,
              External_Name => "__ada_i2c_master_bus_config_t__initialize";
   begin
      Internal
        (Self                   => Self,
         i2c_port               => i2c_port,
         sda_io_num             => sda_io_num,
         scl_io_num             => scl_io_num,
         clk_source             => clk_source,
         glitch_ignore_cnt      => glitch_ignore_cnt,
         intr_priority          => intr_priority,
         trans_queue_depth      => trans_queue_depth,
         enable_internal_pullup => Interfaces.C.C_bool (enable_internal_pullup),
         allow_pd               => Interfaces.C.C_bool (allow_pd));
   end Initialize;

end ESPIDF.Driver.I2C.Master;
