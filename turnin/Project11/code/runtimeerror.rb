# !/arch/unix/bin/ruby

# runtimeerror.rb
# First included in Project 9
# Includes ContractViolation and TimingError.

# This error is raised if a method has broken the contract.
class ContractViolation < RuntimeError
end

# This error is raised if a method is called out of order
# or in essence "at the wrong time."
class TimingError < RuntimeError
end

# This erroris raised if the player is caught cheating.
class Cheating < RuntimeError
end
