require_relative 'constants/en'

module Humanize
  class En
    def humanize(number)
      iteration = 0
      parts = []
      use_and = false
      until number.zero?
        number, remainder = number.divmod(1000)
        unless remainder.zero?
          if iteration.zero? && remainder < 100
            use_and = true
          else
            add_grouping(parts, use_and, iteration)
          end

          parts << SUB_ONE_GROUPING[remainder]
        end

        iteration += 1
      end

      parts
    end
    
    def humanize_with_ordinal(number)
      iteration = 0
      parts = []
      use_and = false
      until number.zero?
        number, remainder = number.divmod(1000)
        unless remainder.zero?
          if iteration.zero? && remainder < 100
            use_and = true
          else
            add_ordinalized_grouping(parts, use_and, iteration)
          end
          
          if parts.length > 0
            parts << SUB_ONE_GROUPING[remainder]
          else
            parts << SUB_ONE_ORDINALIZED_GROUPING[remainder]
          end
        end

        iteration += 1
      end

      parts
    end

    private

    def conjunction(parts, use_and)
      return '' if parts.empty?

      use_and ? ' and' : ','
    end

    def add_grouping(parts, use_and, iteration)
      grouping = LOTS[iteration]
      return unless grouping

      parts << "#{grouping}#{conjunction(parts, use_and)}"
    end
    
    def add_ordinalized_grouping(parts, use_and, iteration)
      if use_and
        grouping = LOTS[iteration]
      else
        grouping = LOTS_ORDINALIZED[iteration]
      end
      return unless grouping

      parts << "#{grouping}#{conjunction(parts, use_and)}"
    end
  end
end
