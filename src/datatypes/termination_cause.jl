"""
    TerminationCause

A enum containg causes for a synthesis process to stop.
"""
@enum TerminationCause begin
    optimal_program_found
    max_enumerations_reached
    max_time_reached
    enumeration_exhausted
end