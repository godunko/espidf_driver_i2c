--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;

private with System.Storage_Elements;

package ESPIDF.Driver.I2C.Master is

   type i2c_master_bus_config_t is private;

   type i2c_master_bus_handle_t is private;

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
      allow_pd               : Boolean               := False);

   function i2c_new_master_bus
     (bus_config     : i2c_master_bus_config_t;
      ret_bus_handle : out i2c_master_bus_handle_t) return esp_err_t
      with Import, Convention => C, Link_Name => "i2c_new_master_bus";

private

   use type Interfaces.C.int;

   sizeof_i2c_master_bus_config_t : constant Interfaces.C.int
      with Import, Link_Name => "__ada_sizeof_i2c_master_bus_config_t";

   type i2c_master_bus_config_t_Storage is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_i2c_master_bus_config_t));

   type i2c_master_bus_config_t is record
      Storage : i2c_master_bus_config_t_Storage := [others => 0];
   end record with Convention => C;

   type i2c_master_bus_t is null record with Convention => C;

   type i2c_master_bus_handle_t is access all i2c_master_bus_config_t;

end ESPIDF.Driver.I2C.Master;
