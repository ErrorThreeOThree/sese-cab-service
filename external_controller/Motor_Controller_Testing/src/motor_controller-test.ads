-- @summary
-- Motor Controller child test package specification.
--
-- @author Julian Hartmer

with AUnit;
with AUnit.Test_Fixtures;

package Motor_Controller.Test is

   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

<<<<<<< HEAD


=======
>>>>>>> b4ad0b18cd504d1982b433ffcc2204c205b91810
   procedure test_calculate_output (T : in out Test);

   procedure test_do_state_transition (T : in out Test);

   procedure test_output_final_safe_state (T : in out Test);

   procedure test_output_system_error (T : in out Test);

   procedure test_output_no_system_error (T : in out Test);

   procedure test_output_front_is_clear (T : in out Test);

   procedure test_output_driving (T : in out Test);
end Motor_Controller.Test;
