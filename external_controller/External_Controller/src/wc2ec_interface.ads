with WC2EC;
with Motor_Controller;
with Front_Distance;
with Job_Executer;
with Roadmarker;
package WC2EC_Interface is

   procedure set_motor_value (ID: Motor_Controller.Motor_ID_T;
                              Value : Long_Float);

   function get_front_distance_value
   (
      typ : in Front_Distance.Sensor_Type_T;
      pos : in Front_Distance.Sensor_Position_T;
      num : in Front_Distance.Sensor_Number_T
   ) return Long_Float;

   function get_rm_sensor_value
   (
      ID        : Roadmarker.Roadmarker_Sensor_ID_T;
      is_backup : Boolean
   ) return Long_Float;

end WC2EC_Interface;
