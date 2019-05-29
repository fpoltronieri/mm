require 'erv'
module Mm
  # TODO Implement RandomWayPoint
  class RandomWayPoint
    #speed and pause are random variable
    #attr_reader :speed, :pause, :position_allocator, :bounding_box
    def initialize(bounding_box=[500, 500], position_allocator = [0.0,0.0,0.0], node_number = 1)
      @state = :not_running
      @event_queue = nil
      @time = Time.now.strftime('%Y%m%d%H%M%S')
      @pause = 2.0
      @speed = ERV::RandomVariable.new(distribution: :uniform ,args: { min_value: 0.3, max_value: 0.7 })
      @position_allocator = position_allocator
      @bounding_box = bounding_box
      @node_number = node_number
      @x_lim = bounding_box[0]
      @y_lim = bounding_box[0]+
      (node_number - 1).times do |i|
      end
    end

    # destination should be [x,y,z]
    def begin_walk()
        @state = :running
        c_speed = speed.sample
        dx = Random.rand(0..1)
        dy = Random.rand(0..1)
        dz = Random.rand(0..1)
        k = c_speed / Math.sqrt(dx**2 + dy**2 + dz**2)
    end


    def new_event(type, data, time)
        raise "Simulation not running" unless @state == :running
        @event_queue << Event.new(type, data, time)
    end

    def run()
        @event_queue = SortedArray.new
        until @event_queue.empty?
            e = @event_queue.shift
        end
    end

    # ns3 code
    # simulate random_waypoint mobility
=begin
   void
 RandomWaypointMobilityModel::BeginWalk (void)
 {
   m_helper.Update ();
   Vector m_current = m_helper.GetCurrentPosition ();
   NS_ASSERT_MSG (m_position, "No position allocator added before using this model");
   Vector destination = m_position->GetNext ();
   double speed = m_speed->GetValue ();
   double dx = (destination.x - m_current.x);
   double dy = (destination.y - m_current.y);
   double dz = (destination.z - m_current.z);
   double k = speed / std::sqrt (dx*dx + dy*dy + dz*dz);
 
   m_helper.SetVelocity (Vector (k*dx, k*dy, k*dz));
   m_helper.Unpause ();
   Time travelDelay = Seconds (CalculateDistance (destination, m_current) / speed);
   m_event.Cancel ();
   m_event = Simulator::Schedule (travelDelay,
                                  &RandomWaypointMobilityModel::DoInitializePrivate, this);
   NotifyCourseChange ();
 }
=end


end