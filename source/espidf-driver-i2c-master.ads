--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;

private with System.Storage_Elements;

package ESPIDF.Driver.I2C.Master is

   type i2c_master_bus_config_t is private;

   type i2c_device_config_t is private;

   type i2c_master_bus_handle_t is private;

   type i2c_master_dev_handle_t is private;

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
     (bus_handle   : i2c_master_bus_handle_t;
      dev_config   : i2c_device_config_t;
      ret_handle   : out i2c_master_dev_handle_t) return esp_err_t
      with Import, Convention => C, Link_Name => "i2c_master_bus_add_device";

   function i2c_del_master_bus
     (bus_handle : in out i2c_master_bus_handle_t) return esp_err_t;

   function i2c_master_bus_rm_device
     (dev_handle : in out i2c_master_dev_handle_t) return esp_err_t;

   function i2c_master_probe
     (bus_handle   : i2c_master_bus_handle_t;
      address      : uint16_t;
      xfer_timeout : Duration) return esp_err_t;

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
