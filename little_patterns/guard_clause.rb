# A guard clause is simply a check that immediately exits the function,
# either with a return statement or an exception.

class GuardClassWithException

  def do_something(item)
    if item == nil
      raise "item must be present to do something to it!"
    end

    item.do_something_else
  end

end

class GuardClassWithReturn

  def do_something(item)
    if item == nil
      return
    end

    item.do_something_else
  end

end

# You can make it a bit nicer to read often via one liners in ruby:
class GuardClassWithReturnOneLiner

  def do_something(item)
    return if item == nil

    item.do_something_else
  end

end

# Make it even more expressive with the .nil? method
class GuardClassWithReturnOneLinerAndNilMethod

  def do_something(item)
    return if item.nil?

    item.do_something_else
  end

end
