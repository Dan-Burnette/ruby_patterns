class ConstructHouse

  def initialize(house_type)
    @house_type = house_type
  end

  def call

    if @house_type == "McMansion"
      build_mc_mansion_house
    elsif @house_type == "Tiny House"
      build_tiny_house
    elsif @house_type == "Multi Family Apartment"
      build_multifamily_apartment
    end

    notify_users_of_new_house_construction

    # ... and so on ... many different types of houses
  end

  private

  def notify_users_of_new_house_construction
    # ... something in our application that needs to happen after we construct a house
  end

  def build_mc_mansion_house
    dig_basement

    #... and so on, a bunch of logic specific to building a McMansion
  end

  def build_tiny_house
    weld_trailer

    #... and so on, a bunch of  logic specific to building a tiny house...
  end

  def build_multi_family_apartment
    build_parking_garage
    build_units

    # ... and so on, a bunch of logic for building an apartment
  end

end


# You can see how this class would quickly spiral out of control as
# you add many types of houses and logic for how to build each one.
