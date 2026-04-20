--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.Driver.I2C.Master is

   function To_MS (Value : Duration) return int;
   --  Converts a Duration to milliseconds, returning -1 if the Duration is
   --  infinite.

   ------------------------
   -- i2c_del_master_bus --
   ------------------------

   function i2c_del_master_bus
     (bus_handle : in out i2c_master_bus_handle_t) return esp_err_t
   is
      function Internal
        (bus_handle : i2c_master_bus_handle_t) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_del_master_bus";

   begin
      return Result : constant esp_err_t := Internal (bus_handle) do
         if Result = ESP_OK then
            bus_handle := null;
         end if;
      end return;
   end i2c_del_master_bus;

   ------------------------------
   -- i2c_master_bus_rm_device --
   ------------------------------

   function i2c_master_bus_rm_device
     (dev_handle : in out i2c_master_dev_handle_t) return esp_err_t
   is
      function Internal
        (dev_handle : i2c_master_dev_handle_t) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_master_bus_rm_device";

   begin
      return Result : constant esp_err_t := Internal (dev_handle) do
         if Result = ESP_OK then
            dev_handle := null;
         end if;
      end return;
   end i2c_master_bus_rm_device;

   ----------------------
   -- i2c_master_probe --
   ----------------------

   function i2c_master_probe
     (bus_handle   : i2c_master_bus_handle_t;
      address      : uint16_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t
   is
      function Internal
        (bus_handle       : i2c_master_bus_handle_t;
         address          : uint16_t;
         xfer_timeout_ms  : int) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_master_probe";

      Xfer_Timeout_Ms : constant int := To_MS (xfer_timeout);

   begin
      return Internal (bus_handle, address, Xfer_Timeout_Ms);
   end i2c_master_probe;

   ------------------------
   -- i2c_master_receive --
   ------------------------

   function i2c_master_receive
     (i2c_dev      : i2c_master_dev_handle_t;
      read_buffer  : System.Address;
      read_size    : size_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t
   is
      function Internal
        (i2c_dev         : i2c_master_dev_handle_t;
         read_buffer     : System.Address;
         read_size       : size_t;
         xfer_timeout_ms : int) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_master_receive";

      Xfer_Timeout_Ms : constant int := To_MS (xfer_timeout);

   begin
      return Internal (i2c_dev, read_buffer, read_size, Xfer_Timeout_Ms);
   end i2c_master_receive;

   ------------------------
   -- i2c_master_receive --
   ------------------------

   function i2c_master_receive
     (i2c_dev      : i2c_master_dev_handle_t;
      read_buffer  : out A0B.Types.Arrays.Unsigned_8_Array;
      xfer_timeout : Duration := Duration'Last) return esp_err_t is
   begin
      return
        i2c_master_receive
          (i2c_dev      => i2c_dev,
           read_buffer  => read_buffer'Address,
           read_size    => read_buffer'Length,
           xfer_timeout => xfer_timeout);
   end i2c_master_receive;

   -------------------------
   -- i2c_master_transmit --
   -------------------------

   function i2c_master_transmit
     (i2c_dev      : i2c_master_dev_handle_t;
      write_buffer : System.Address;
      write_size   : size_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t
   is
      function Internal
        (i2c_dev         : i2c_master_dev_handle_t;
         write_buffer    : System.Address;
         write_size      : size_t;
         xfer_timeout_ms : int) return esp_err_t
         with Import, Convention => C, Link_Name => "i2c_master_transmit";

      Xfer_Timeout_Ms : constant int := To_MS (xfer_timeout);

   begin
      return Internal (i2c_dev, write_buffer, write_size, Xfer_Timeout_Ms);
   end i2c_master_transmit;

   -------------------------
   -- i2c_master_transmit --
   -------------------------

   function i2c_master_transmit
     (i2c_dev      : i2c_master_dev_handle_t;
      write_buffer : A0B.Types.Arrays.Unsigned_8_Array;
      xfer_timeout : Duration := Duration'Last) return esp_err_t is
   begin
      return
        i2c_master_transmit
          (i2c_dev      => i2c_dev,
           write_buffer => write_buffer'Address,
           write_size   => write_buffer'Length,
           xfer_timeout => xfer_timeout);
   end i2c_master_transmit;

   --------------------------------------
   -- i2c_master_multi_buffer_transmit --
   --------------------------------------

   function i2c_master_multi_buffer_transmit
     (i2c_dev           : i2c_master_dev_handle_t;
      buffer_info_array : i2c_master_transmit_multi_buffer_info_t_Array;
      xfer_timeout      : Duration := Duration'Last) return esp_err_t
   is
      function Internal
        (i2c_dev           : i2c_master_dev_handle_t;
         buffer_info_array : System.Address;
         array_size        : size_t;
         xfer_timeout_ms   : int) return esp_err_t
         with Import,
              Convention => C,
              Link_Name => "i2c_master_multi_buffer_transmit";

      Xfer_Timeout_Ms : constant int := To_MS (xfer_timeout);

   begin
      return Internal
        (i2c_dev           => i2c_dev,
         buffer_info_array => buffer_info_array'Address,
         array_size        => buffer_info_array'Length,
         xfer_timeout_ms   => Xfer_Timeout_Ms);
   end i2c_master_multi_buffer_transmit;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Configuration     : out i2c_device_config_t;
      dev_addr_length   : i2c_addr_bit_len_t;
      device_address    : uint16_t;
      scl_speed_hz      : uint32_t;
      scl_wait          : Duration := 0.0;
      disable_ack_check : Boolean := False)
   is
      procedure Internal
        (Configuration     : out i2c_device_config_t;
         dev_addr_length   : i2c_addr_bit_len_t;
         device_address    : uint16_t;
         scl_speed_hz      : uint32_t;
         scl_wait_us       : uint32_t;
         disable_ack_check : bool)
         with Import,
              Convention => C,
              External_Name => "__ada_i2c_device_config_t__initialize";

      Scl_Wait_Us : constant uint32_t := uint32_t (scl_wait * 1_000_000);

   begin
      Internal
        (Configuration     => Configuration,
         dev_addr_length   => dev_addr_length,
         device_address    => device_address,
         scl_speed_hz      => scl_speed_hz,
         scl_wait_us       => Scl_Wait_Us,
         disable_ack_check => bool (disable_ack_check));
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Configuration          : out i2c_master_bus_config_t;
      i2c_port               : i2c_port_num_t     := -1;
      sda_io_num             : gpio_num_t;
      scl_io_num             : gpio_num_t;
      clk_source             : i2c_clock_source_t := I2C_CLK_SRC_DEFAULT;
      glitch_ignore_cnt      : uint8_t            := 7;
      intr_priority          : int                := 0;
      trans_queue_depth      : size_t             := 0;
      enable_internal_pullup : Boolean            := False;
      allow_pd               : Boolean            := False)
   is
      procedure Internal
        (Configuration          : out i2c_master_bus_config_t;
         i2c_port               : i2c_port_num_t;
         sda_io_num             : gpio_num_t;
         scl_io_num             : gpio_num_t;
         clk_source             : i2c_clock_source_t;
         glitch_ignore_cnt      : uint8_t;
         intr_priority          : int;
         trans_queue_depth      : size_t;
         enable_internal_pullup : bool;
         allow_pd               : bool)
         with Import,
              Convention => C,
              External_Name => "__ada_i2c_master_bus_config_t__initialize";
   begin
      Internal
        (Configuration          => Configuration,
         i2c_port               => i2c_port,
         sda_io_num             => sda_io_num,
         scl_io_num             => scl_io_num,
         clk_source             => clk_source,
         glitch_ignore_cnt      => glitch_ignore_cnt,
         intr_priority          => intr_priority,
         trans_queue_depth      => trans_queue_depth,
         enable_internal_pullup => bool (enable_internal_pullup),
         allow_pd               => bool (allow_pd));
   end Initialize;

   -----------
   -- To_MS --
   -----------

   function To_MS (Value : Duration) return int is
      use type int;

   begin
      if Value = Duration'Last then
         return -1;

      else
         return int (Value * 1_000);
      end if;
   end To_MS;

end ESPIDF.Driver.I2C.Master;
