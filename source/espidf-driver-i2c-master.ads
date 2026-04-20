--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;

with System;
private with System.Storage_Elements;

with A0B.Types.Arrays;

package ESPIDF.Driver.I2C.Master is

   type i2c_master_bus_config_t is private;

   type i2c_device_config_t is private;

   type i2c_master_bus_handle_t is private;

   type i2c_master_dev_handle_t is private;

   type i2c_master_transmit_multi_buffer_info_t is record
      buffer : System.Address;
      length : size_t;
   end record with Convention => C;

   type i2c_master_transmit_multi_buffer_info_t_Array is
     array (Natural range <>) of i2c_master_transmit_multi_buffer_info_t
       with Convention => C;

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
      allow_pd               : Boolean            := False);

   procedure Initialize
     (Configuration     : out i2c_device_config_t;
      dev_addr_length   : i2c_addr_bit_len_t;
      device_address    : uint16_t;
      scl_speed_hz      : uint32_t;
      scl_wait          : Duration := 0.0;
      disable_ack_check : Boolean  := False);

   function i2c_new_master_bus
     (bus_config     : i2c_master_bus_config_t;
      ret_bus_handle : out i2c_master_bus_handle_t) return esp_err_t
      with Import, Convention => C, Link_Name => "i2c_new_master_bus";

   function i2c_master_bus_add_device
     (bus_handle : i2c_master_bus_handle_t;
      dev_config : i2c_device_config_t;
      ret_handle : out i2c_master_dev_handle_t) return esp_err_t
      with Import, Convention => C, Link_Name => "i2c_master_bus_add_device";

   function i2c_del_master_bus
     (bus_handle : in out i2c_master_bus_handle_t) return esp_err_t;

   function i2c_master_bus_rm_device
     (dev_handle : in out i2c_master_dev_handle_t) return esp_err_t;

   function i2c_master_transmit
     (i2c_dev      : i2c_master_dev_handle_t;
      write_buffer : System.Address;
      write_size   : size_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t;

   function i2c_master_transmit
     (i2c_dev      : i2c_master_dev_handle_t;
      write_buffer : A0B.Types.Arrays.Unsigned_8_Array;
      xfer_timeout : Duration := Duration'Last) return esp_err_t;

   function i2c_master_multi_buffer_transmit
     (i2c_dev           : i2c_master_dev_handle_t;
      buffer_info_array : i2c_master_transmit_multi_buffer_info_t_Array;
      xfer_timeout      : Duration := Duration'Last) return esp_err_t;

   function i2c_master_receive
     (i2c_dev      : i2c_master_dev_handle_t;
      read_buffer  : System.Address;
      read_size    : size_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t;

   function i2c_master_receive
     (i2c_dev      : i2c_master_dev_handle_t;
      read_buffer  : out A0B.Types.Arrays.Unsigned_8_Array;
      xfer_timeout : Duration := Duration'Last) return esp_err_t;

   function i2c_master_probe
     (bus_handle   : i2c_master_bus_handle_t;
      address      : uint16_t;
      xfer_timeout : Duration := Duration'Last) return esp_err_t;

private

   sizeof_i2c_master_bus_config_t : constant int
      with Import, Link_Name => "__ada_sizeof_i2c_master_bus_config_t";
   sizeof_i2c_device_config_t     : constant int
      with Import, Link_Name => "__ada_sizeof_i2c_device_config_t";

   type i2c_master_bus_config_t_Storage is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_i2c_master_bus_config_t));

   type i2c_master_bus_config_t is record
      Storage : i2c_master_bus_config_t_Storage := [others => 0];
   end record with Convention => C;

   type i2c_device_config_t is record
      Storage : System.Storage_Elements.Storage_Array
                  (1 .. System.Storage_Elements.Storage_Count
                          (sizeof_i2c_device_config_t)) := [others => 0];
   end record with Convention => C;

   type i2c_master_bus_t is null record with Convention => C;

   type i2c_master_bus_handle_t is access all i2c_master_bus_config_t;

   type i2c_master_dev_t is null record with Convention => C;

   type i2c_master_dev_handle_t is access all i2c_master_dev_t;

end ESPIDF.Driver.I2C.Master;
