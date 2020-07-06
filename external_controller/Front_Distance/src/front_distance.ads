with Motor_Controller; use Motor_Controller;
package Front_Distance is

   -- Enumartion to reference the front distance sensor by their position.
   -- @value CENTER middle sensor
   -- @value LEFT left sensor
   -- @value RIGHT right sensor
   type Sensor_Position_T is
     (CENTER, LEFT, RIGHT);

   -- Type to reference the sensor by their number. Each number is used for
   -- one duplicate sensor array.
   subtype Sensor_Number_T is Integer range 0..1;

   -- Enumartion to reference the sensors by their type.
   -- @value IR infrared sensor
   -- @value US ultra sonic sensor
   type Sensor_Type_T is (IR, US);

   -- Array to store all sensor values.
   -- Only global for unit testing purposes.
   type All_Sensor_Values_Array_T is array (Sensor_Type_T, Sensor_Position_T, Sensor_Number_T) of Long_Float;

   -- Array to store all sensor threshholds.
   -- Only global for unit testing purposes.
   type Threshhold_Array_T is array (Sensor_Type_T) of Long_Float;

   -- Returns the Front_Distance_Done_T Signal from sensor data.
   -- It returns FD_FAULT_S when all sensor types are faulty. A sensor type
   -- is fault, when every sensor of this type at one position is faulty.
   -- If a sensor type is not faulty and at least one sensor detects an object,
   -- the function returns FRONT_BLOCKED. In every other case, it returns
   -- FRONT_CLEAR.
   -- Global for testing purposes
   function calculate_output
     (
      all_sensor_values : in All_Sensor_Values_Array_T;
      threshholds       : in Threshhold_Array_T
     ) return Front_Distance_Done_t;

   -- Acces type to getter function for front distance sensor values.
   -- The sensor is referenced by type, position and number.
   type get_sensor_value_access is access
     function
       (
        typ : in Sensor_Type_T;
        pos : in Sensor_Position_T;
        num : in Sensor_Number_T
       ) return Long_Float;

   -- Task to fetch and evaluate front distance sensor values. Communicates
   -- with the External Controller Task by calling the entries
   -- Front_Distance_Next and Front_Distance_Done.
   task type Front_Distance_Task_T is
      entry Construct
        (
         get_sensor_value_a               : in get_sensor_value_access;
         us_thresh                        : in Long_Float;
         ir_thresh                        : in Long_Float;
         Motor_Controller_Task_A          : in Motor_Controller_Task_Access_T;
         timeout_v                        : in Duration
        );
   end Front_Distance_Task_T;

end Front_Distance;
