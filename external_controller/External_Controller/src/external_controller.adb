with Lane_Detection;   use Lane_Detection;
with Motor_Controller; use Motor_Controller;
with WC2EC;            use WC2EC;
with Ada.Text_IO;      use Ada.Text_IO;
with Front_Distance;   use Front_Distance;
with Job_Executer;     use Job_Executer;
with WC2EC_Interface;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets; use GNAT.Sockets;

procedure External_Controller is
   Lane_Detection_Task   : Lane_Detection_Taks_T;
   Front_Distance_Task   : Front_Distance_Task_T;
   Motor_Controller_Task : Motor_Controller_Task_Access_T;
   Job_Executer_Task     : Job_Executer_Task_T;
   WC2EC_Driver          : wc2ec_thread_access_t;
   --job_execute_next_v    : Job_Executer_Next_t;
   ip                    : Ada.Strings.Unbounded.Unbounded_String := To_Unbounded_String("127.0.0.1");
   port                  : Port_Type := 27015;
   cab_name              : Ada.Strings.Unbounded.Unbounded_String := To_Unbounded_String("default");
   start_section         : Integer := 0;

   procedure Log_Line(message : String) is
   begin
      Put_Line("[external_controller] " & message);
   end Log_Line;

begin
   Put_Line("Command line arguments: " & Ada.Command_Line.Argument_Count'Image);
   if (Ada.Command_Line.Argument_Count = 4) then
      ip := To_Unbounded_String(Argument(1));
      port := Port_Type'Value(Argument(2));
      cab_name := To_Unbounded_String(Argument(3));
      start_section := Integer'Value(Argument(4));
   end if;
   Log_Line ("Setting up WC2EC_Driver...");
   WC2EC_Driver := new wc2ec_thread_t;
   WC2EC_Driver.Constructor(ip, port);
   while WC2EC.ready /= True loop
      delay 1.0;
   end loop;

   Log_Line ("Setting up Motor_Controller_Task...");
   Motor_Controller_Task := new Motor_Controller_Task_T;

   Motor_Controller_Task.Constructor(MC_State       => NORMAL_DRIVING,
                                     ND_State       => FRONT_CLEAR,
                                     FC_State       => DRIVE,
                                     D_State        => INIT,
                                     SE_State       => STOP,
                                     LE_STATE       => NEXT_UNKOWN,
                                     MS_Speed       => 3.0,
                                     MT_Speed       => 1.5,
                                     set_motor_value_access => WC2EC_Interface.set_motor_value'Access,
                                     timeout_v      => 1.3,
                                     iteration_delay_s => 0.01);

   Log_Line ("Setting up Lane_Detection_Task...");
   Lane_Detection_Task.Construct
     (IR_Threshhold => 350.0, US_Threshhold => 870.0, US_Max_Value => 1_000.0,
      Motor_Task_A  => Motor_Controller_Task, WC2EC_Driver_A => WC2EC_Driver);

   Log_Line("Setting up Front_Distance_Task ...");
   Front_Distance_Task.Construct
     (get_sensor_value_a               => WC2EC_Interface.get_front_distance_value'Access ,
      us_thresh                        => 300.0,
      ir_thresh                        => 300.0,
      Motor_Controller_Task_A          => Motor_Controller_Task,
      timeout_v                        => 2.0
     );
   Log_Line("All set up!");

   Job_Executer_Task.Constructor(Motor_Controller_Task_A => Motor_Controller_Task,
                                 timeout_v               => 1.5,
                                 RM_get_sensor_value_a   => WC2EC_Interface.get_rm_sensor_value'Access,
                                 cab_name_arg => cab_name,
                                 start_section_arg => start_section);

   loop
      -- Motor_Controller_Task.job_executer_done(NEXT_LEFT_S);
      -- HINT uncomment the above line to enabel job_executer

      Motor_Controller_Task.main_shutdown_signal(False);

      -- Motor_Controller_Task.job_executer_next(job_execute_next_v);
      -- HINT uncomment the above line to enabel job_executer
   end loop;


end External_Controller;
