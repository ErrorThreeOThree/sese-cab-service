with Lane_Detection;   use Lane_Detection;
with Motor_Controller; use Motor_Controller;
with WC2EC;            use WC2EC;
with Ada.Text_IO;      use Ada.Text_IO;
with Front_Distance;   use Front_Distance;
with WC2EC_Interface;



procedure External_Controller is
   Lane_Detection_Task   : Lane_Detection_Taks_T;
   Front_Distance_Task   : Front_Distance_Task_T;
   Motor_Controller_Task : Motor_Controller_Task_Access_T;
   WC2EC_Driver          : wc2ec_thread_access_t;

   procedure Log_Line(message : String) is
   begin
      Put_Line("[external_controller] " & message);
   end Log_Line;

begin
   Log_Line ("Setting up WC2EC_Driver...");
   WC2EC_Driver := new wc2ec_thread_t;
   while WC2EC.ready /= True loop
      delay 1.0;
   end loop;

   Log_Line ("Setting up Motor_Controller_Task...");
   Motor_Controller_Task := new Motor_Controller_Task_T;

   Motor_Controller_Task.Construct(MC_State       => NORMAL_DRIVING,
                                   ND_State       => FRONT_CLEAR,
                                   FC_State       => DRIVE,
                                   D_State        => INIT,
                                   SE_State       => STOP,
                                   MS_Speed       => 6.0,
                                   MT_Speed       => 1.0,
                                   set_motor_value_access => WC2EC_Interface.set_motor_value'Access);

   Log_Line ("Setting up Lane_Detection_Task...");
   Lane_Detection_Task.Construct
     (IR_Threshhold => 250.0, US_Threshhold => 870.0, US_Max_Value => 1_000.0,
      Motor_Task_A  => Motor_Controller_Task, WC2EC_Driver_A => WC2EC_Driver);

   Log_Line("Setting up Front_Distance_Task ...");
   Front_Distance_Task.Construct
     (get_distance_sensor_value_access => WC2EC_Interface.get_front_distance_value'Access ,
      us_thresh                        => 600.0,
      Motor_Controller_Task_A          => Motor_Controller_Task
     );
   Log_Line("All set up!");

end External_Controller;
