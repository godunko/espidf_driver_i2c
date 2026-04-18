--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with Interfaces.C;

package ESPIDF with Pure is

   type esp_err_t is new Interfaces.C.int;

   ESP_OK : constant esp_err_t := 0;

end ESPIDF;
