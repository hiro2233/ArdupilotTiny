// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

//
// Simple test for the AP_Scheduler interface
//
#include <Arduino.h>
#include <AP_Common.h>
#include <AP_HAL.h>
#include <AP_Scheduler.h>
#include <AP_HAL_AVR.h>

#define TIME_MAIN_LOOP 10

const AP_HAL::HAL& hal = AP_HAL_BOARD_DRIVER;

class SchedTest {
public:
    void setup();
    void loop();

private:

    AP_Scheduler scheduler;

    uint32_t tick_counter;
    static const AP_Scheduler::Task scheduler_tasks[];

    void ins_update(void);
    void one_hz_print(void);
    void five_second_call(void);
};

static SchedTest schedtest;

#define SCHED_TASK(func) FUNCTOR_BIND(&schedtest, &SchedTest::func, void)

/*
  scheduler table - all regular tasks are listed here, along with how
  often they should be called (in TIME_MAIN_LOOP ms units) and the maximum time
  they are expected to take (in microseconds)
 */
const AP_Scheduler::Task SchedTest::scheduler_tasks[] PROGMEM = {
    { SCHED_TASK(ins_update),             1,   2000 },
    { SCHED_TASK(one_hz_print),         100,   2000 },
    { SCHED_TASK(five_second_call),     500,   2000 },
};

uint16_t counter1 = 0;
float percent = 0;
void SchedTest::setup(void)
{
    pinMode(13, OUTPUT);
    digitalWrite(13, HIGH);

    // initialise the scheduler
    scheduler.init(&scheduler_tasks[0], ARRAY_SIZE(scheduler_tasks));
}

void SchedTest::loop(void)
{
    hal.scheduler->delay(TIME_MAIN_LOOP);

    // tell the scheduler one tick has passed
    scheduler.tick();

    // run all tasks that fit in 20ms
    scheduler.run(20000);

}

/*
  update inertial sensor, reading data 
 */
void SchedTest::ins_update(void)
{
    tick_counter++;
}

/*
  print something once a second
 */
void SchedTest::one_hz_print(void)
{
    hal.console->printf("one_hz: ins_counter=%lu \n", (unsigned long)tick_counter);
    digitalWrite(13, !digitalRead(13));
}

/*
  print something every 5 seconds
 */
void SchedTest::five_second_call(void)
{
    hal.console->printf("five_seconds: ins_counter=%u\n", tick_counter);
    tick_counter = 0;
}

/*
  compatibility with old pde style build
 */
void setup(void);
void loop(void);

void setup(void)
{

    schedtest.setup();
}
void loop(void)
{
    schedtest.loop();
}
AP_HAL_MAIN();
