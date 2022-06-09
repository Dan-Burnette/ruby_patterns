# Solution: replace type code with classes and utilize so called "Duck typing"

class ConstructHouse

  def initialize(house_type)
    @house_type = house_type
  end

  def call
    house_type.construct

    notify_users_of_new_house_construction
  end

  private 

  def notify_users_of_new_house_construction
    # ... something in our application that needs to happen after we construct a house
  end
end

class McMansion

  def self.construct
    dig_basement

    # ...
  end

  def dig_basement
    # ...
  end

end

class TinyHouse

  def self.construct
    weld_trailer

    # ...
  end

  private
  
  def weld_trailer
    # ...
  end

end

class MultiFamilyApartment

  def self.construct
    build_parking_garage
    build_units

    # ...
  end

  private

  def build_parking_garage
    # ...
  end

  def build_units
    # ...
  end

end


# Now we can build the different types of houses like:

ConstructHouse.new(McMansion).construct
ConstructHouse.new(TinyHouse).construct
ConstructHouse.new(MultiFamilyApartment).construct


# Duck typing means relying on a class to implement a method.
# Here we are relying on each of these classes (McMansion, TinyHouse, and MultiFamilyApartment)
# to implement the .construct class method.
#
#
# If it quacks like a duck, you can treat it like a duck. In our case, if it responds to a construct
#
# class method, we can pass it into ConstructHouse
