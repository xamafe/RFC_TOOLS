# RFC_TOOLS

Hi there, nice to meet you.

As you know it is unpleasant to work with aRFC, not mentioning aRFC with a regular RFC call to fetch data from multiple systems in parallel.
After I struggled some time with the approach from the SAP I decided to write a wrapper for developers, which is capable of handling the "standard - stuff"
The idea is simple: each parallel task is managed by its own instance of the wrapper class.

To use it, follow these easy steps:
1. create a child class from zcl_async__base
2. choose a function module which should be handled by the class
3. create Attributes and setter/getter methods for all parameters of the function module
4. implement call_function with the following conditions:  
>>*STARTING NEW TASK taskname  
>>*CALLING me->receive_data ON END OF TASK  
>>*EXCEPTIONS  
>>     system_failure        = 1  MESSAGE e_message  
>>     communication_failure = 2  MESSAGE e_message  
>>     resource_failure      = 3  
>>*Make sure if sy-subrc = 3 that e_insufficient_ressources is set to abap_true
5. implement receive_function  
  
I'm going to implement an example as soon as possible :-)
  
NEXT STEPS:  
* implement an example!
* add RFC - Connections to the base - class
* add RFC Groups to the base - class
