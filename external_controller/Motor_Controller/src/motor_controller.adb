-- Final safe state not implemented yet!
pragma Ada_2012;
with Ada.Text_IO; use Ada.Text_IO;
package body Motor_Controller is

   procedure print_motor_value (f : Float) is
   begin
      Put (f'Image);
   end print_motor_value;

   type Module_Tasks is (LANE_DETECTION, JOB_EXECUTER, FRONT_DISTANCE);
   type Boolean_Tasks_Arrays is array (Module_Tasks) of Boolean;

   ---------------------------
   -- Motor_Controller_Task --
   ---------------------------

   task body Motor_Controller_Task_T is
      Motor_Controller_State : Motor_Controller_State_T := NORMAL_DRIVING;
      Normal_Driving_State   : Normal_Driving_State_T   := FRONT_CLEAR;
      Front_Clear_State      : Front_Clear_State_T      := DRIVE;
      Drive_State            : Drive_State_T            := STRAIGHT;
      Lean_State             : Lean_State_T             := NEXT_UNKOWN;
      System_Error_State     : System_Error_State_T     := STOP;
      Motor_Straight_Speed   : Long_Float;
      Motor_Turn_Speed       : Long_Float;
      set_motor_value        : set_motor_value_procedure_t;
      running                : Boolean                  := True;
      timeout                : Duration                 := 2.0;
      Job_Executer_Next_Signal : Job_Executer_Next_t    := EMPTY_S;
      Lane_Detection_Next_Signal : Lane_Detection_Next_T:= EMPTY_S;
      Front_Distance_Next_Signal : Front_Distance_Next_t:= EMPTY_S;
      task_done_array            : Boolean_Tasks_Arrays;

      procedure Log_Line (message : String) is
      begin
         Put_Line ("[motor_controller] " & message);
      end Log_Line;

      procedure drive_state_output is
      begin
         case Lean_State is
            when NEXT_LEFT =>
               Lane_Detection_Next_Signal := LEAN_LEFT_S;
            when NEXT_RIGHT =>
               Lane_Detection_Next_Signal := LEAN_RIGHT_S;
            when NEXT_UNKOWN =>
               Lane_Detection_Next_Signal := NO_LEAN_S;
         end case;

         case Drive_State is
            when STRAIGHT =>
               Log_Line ("driving straight");
               set_motor_value (MOTOR_FRONT_LEFT, Motor_Straight_Speed);
               set_motor_value (MOTOR_BACK_LEFT, Motor_Straight_Speed);
               set_motor_value (MOTOR_FRONT_RIGHT, Motor_Straight_Speed);
               set_motor_value (MOTOR_BACK_RIGHT, Motor_Straight_Speed);
            when LEFT =>
               Log_Line ("driving left");
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, Motor_Turn_Speed);
               set_motor_value (MOTOR_BACK_RIGHT, Motor_Turn_Speed);
            when RIGHT =>
               Log_Line ("driving right");
               set_motor_value (MOTOR_FRONT_LEFT, Motor_Turn_Speed);
               set_motor_value (MOTOR_BACK_LEFT, Motor_Turn_Speed);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);
            when INIT =>
               Log_Line ("driving Init");
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);
         end case;

      end drive_state_output;

      procedure front_clear_state_output is
      begin
         case Front_Clear_State is
            when DRIVE =>
               Log_Line ("Drive state");
               drive_state_output;
            when STOP =>
               Log_Line ("Stop state");
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);
         end case;
      end front_clear_state_output;

      procedure normal_driving_state_output is
      begin
         case Normal_Driving_State is
            when FRONT_CLEAR =>
               Log_Line ("Front clear state");
               front_clear_state_output;
            when FRONT_BLOCKED =>
               Log_Line ("Front Blocked State");
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);

         end case;
      end normal_driving_state_output;

      procedure calculate_outputs is
      begin
         case Motor_Controller_State is
            when NORMAL_DRIVING =>
               Log_Line ("Normal Driving state");
               normal_driving_state_output;
            when SYSTEM_ERROR =>
               Log_Line ("System error state");
               -- TODO implement system_error
         end case;
      end calculate_outputs;


      ----------------------------------------
      -- Function handling the done signals --
      ----------------------------------------

      procedure handle_lane_detection_done
        (Lane_Detection_Signal_Value : in Lane_Detection_Done_T)
      is
      begin
         case Lane_Detection_Signal_Value is
            when SYSTEM_ERROR_S =>
               Motor_Controller_State := SYSTEM_ERROR;
               -- TODO: Handle System_Error
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);
               Motor_Controller_State := SYSTEM_ERROR;

            when GO_STRAIGHT_S =>
               Drive_State := STRAIGHT;
            when GO_LEFT_S =>
               Drive_State := LEFT;
            when GO_RIGHT_S =>
               Drive_State := RIGHT;
            when EMPTY_S =>
               null;
         end case;
      end handle_lane_detection_done;

      procedure handle_front_distance_done
        (Front_Distance_Signal_Value : in Front_Distance_Done_t)
      is
      begin
         case Front_Distance_Signal_Value is
            when SYSTEM_ERROR_S =>
               -- TODO handle system error
               set_motor_value (MOTOR_FRONT_LEFT, 0.0);
               set_motor_value (MOTOR_BACK_LEFT, 0.0);
               set_motor_value (MOTOR_FRONT_RIGHT, 0.0);
               set_motor_value (MOTOR_BACK_RIGHT, 0.0);
               Motor_Controller_State := SYSTEM_ERROR;
            when FRONT_BLOCKED_S =>
               Normal_Driving_State := FRONT_BLOCKED;
            when FRONT_CLEAR_S =>
               Normal_Driving_State := FRONT_CLEAR;
            when EMPTY_S =>
               null;
         end case;
      end handle_front_distance_done;

      procedure handle_job_executer_done
        (Signal : in Job_Executer_Done_T)
      is
      begin
         case Signal is
            when SYSTEM_ERROR_S =>
               Lean_State := NEXT_LEFT;
               --Lane_Detection_Next_Signal := LEAN_LEFT_S;
               null;
            when NEXT_LEFT_S =>
               Lean_State := NEXT_LEFT;
               --Lane_Detection_Next_Signal := LEAN_LEFT_S;
               null;
            when NEXT_RIGHT_S =>
               Lean_State := NEXT_RIGHT;
               --Lane_Detection_Next_Signal := LEAN_RIGHT_S;
               null;
            when NEXT_UNKOWN_S =>
               Lean_State := NEXT_UNKOWN;
               --Lane_Detection_Next_Signal := NO_LEAN_S;
               null;
            when EMPTY_S =>
               -- dont change state
               null;
            when STOP_S =>
               Front_Clear_State := STOP;
               --Lane_Detection_Next_Signal := NO_LEAN_S;
               null;
         end case;
      end handle_job_executer_done;

      procedure reset_all_tasks_done(all_tasks_done_array : in out Boolean_Tasks_Arrays)
      is
      begin
         for I in Module_Tasks loop
            all_tasks_done_array(I) := False;
         end loop;
      end reset_all_tasks_done;

      function are_all_tasks_done(all_tasks_done_array : in out Boolean_Tasks_Arrays) return Boolean
      is
      begin
         for I in Module_Tasks loop
            if not all_tasks_done_array(I) then
               return False;
            end if;
         end loop;
         return True;

      end are_all_tasks_done;


   begin
      -- accept constructor call
      -- on timeout, close motor controller this is needed so that test cases
      -- termintate if an assert fails
      select
         delay timeout;
         Log_Line ("Constructor Timed out, exiting motor_controller");
         running := False;
      or
         accept Constructor(MC_State             : in Motor_Controller_State_T;
                          ND_State               : in Normal_Driving_State_T;
                          FC_State               : in Front_Clear_State_T;
                          D_State                : in Drive_State_T;
                          LE_State               : in Lean_State_T;
                          SE_State               : in System_Error_State_T;
                          MS_Speed               : in Long_Float;
                          MT_Speed               : in Long_Float;
                          set_motor_value_access : in set_motor_value_procedure_t;
                          timeout_v              : in Duration)
         do
            Motor_Controller_State := MC_State;
            Normal_Driving_State   := ND_State;
            Front_Clear_State      := FC_State;
            Drive_State            := D_State;
            Lean_State             := LE_State;
            System_Error_State     := SE_State;
            Motor_Straight_Speed   := MS_Speed;
            Motor_Turn_Speed       := MT_Speed;
            set_motor_value        := set_motor_value_access;
            timeout                := timeout;

         end Constructor;
      end select;

      -- main loop
      while running loop

         -- look for all signals -> order not set Break when every task raised
         -- each task will send one Signal

         -- When timeout, we the controller

          -- initialize task_done_array
         reset_all_tasks_done(all_tasks_done_array => task_done_array);

         while not are_all_tasks_done(task_done_array) loop
            select
               accept job_executer_done (Signal : in Job_Executer_Done_T) do
                  handle_job_executer_done (Signal);
                  task_done_array(JOB_EXECUTER) := True;
               end job_executer_done;
            or
               accept lane_detection_done
                 (Signal : in Lane_Detection_Done_T)
               do
                  handle_lane_detection_done (Signal);
                  task_done_array(LANE_DETECTION) := True;
               end lane_detection_done;
            or

               accept front_distance_done
                 (Signal : in Front_Distance_Done_t)
               do
                  handle_front_distance_done (Signal);
                  task_done_array(FRONT_DISTANCE) := True;
               end front_distance_done;
            or
               delay 2.0;
               Log_Line
                 ("done signals timed out, killing External_Controller");

               for I in Module_Tasks loop
                  Log_Line("tasks_done_array(" & I'Image & ") = " & task_done_array(I)'Image);
               end loop;

               running := False;

               goto Continue;
            end select;

         end loop;


         -- Output stuff depending on State
         -- This has to be done before processing of main_shutdown_signal,
         -- because main_shutdown_signal may override those signals
         calculate_outputs;

         -- check for main task to exit
         select
            accept main_shutdown_signal (is_shutdown : in Boolean) do
               if is_shutdown then
                  running := False;
                  Lane_Detection_Next_Signal := SHUTDOWN_S;
                  Front_Distance_Next_Signal := SHUTDOWN_S;
                  Job_Executer_Next_Signal   := SHUTDOWN_S;
               end if;
            end main_shutdown_signal;
         or
            delay 2.0;
            Log_Line
              ("main_shutdown_signal timed out, killing External_Controller");
            running := False;
            goto Continue;
         end select;




         reset_all_tasks_done(all_tasks_done_array => task_done_array);

         -- all tasks wait before the motor_controller does its transistion
         -- Signal all tasks to unless it is system_error

         while not are_all_tasks_done(task_done_array) loop
            select
               accept job_executer_next (Signal : out Job_Executer_Next_t)
               do
                  Signal := Job_Executer_Next_Signal;
                  task_done_array(JOB_EXECUTER) := True;
               end job_executer_next;
            or
               accept lane_detection_next
                 (Signal : out Lane_Detection_Next_T)
               do
                  Signal := Lane_Detection_Next_Signal;
                  task_done_array(LANE_DETECTION) := True;
               end lane_detection_next;
            or
               accept front_distance_next (Signal : out Front_Distance_Next_t) do
                  Signal := Front_Distance_Next_Signal;
                  task_done_array(FRONT_DISTANCE) := True;
               end front_distance_next;
            or
               delay 2.0;
               Log_Line
                 ("next signals timed out, killing External_Controller");

               for I in Module_Tasks loop
                  Log_Line("tasks_done_array(" & I'Image & ") = " & task_done_array(I)'Image);
               end loop;

               running := False;

               goto Continue;
            end select;

         end loop;

         <<Continue>>
      end loop;
      Log_Line
        ("Motor_Controller shutting down. So long, and thanks for all the gasoline");

   end Motor_Controller_Task_T;

end Motor_Controller;
