 module Securetrading
   class Billing < BaseModel
     private

     def sub_classes
       %w(amount name dcc payment)
     end
   end
 end
