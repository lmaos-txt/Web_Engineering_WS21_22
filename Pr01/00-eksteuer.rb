# !/usr/bin/env ruby
# Otto Santovenia, Luis Manuel Alfred, 1190173, 28.10.2021

class Einkommen
    # Berechnet den Grenzsteuersatz aus dem gegebenen
    # zu versteuernden Einkommen (zvE).

    def initialize()
        @range_std = [[0,9408],[9409,14532],[14533,57051],[57052,270500],[270501,1 <<64]]
        @range_split = [[0,18816],[18817,29064],[29065,114102],[114103,541000],[541001,1 <<64]]
        @range_use= @range_std
        @flag = false
    end


    def grenzsteuersatz(zvE)
        return if !checkNumeric(zvE)
        return 0 if zvE < 1
        zvE = zvE.to_i.to_f.round(0)
        # check where my input is
        if zvE.between?(@range_use[0][0],@range_use[0][1])
            return 0
        elsif zvE.between?(@range_use[1][0],@range_use[1][1])
            return geradengleichung([@range_use[1][0],0.14],[@range_use[2][0],0.2397],zvE)
        elsif zvE.between?(@range_use[2][0],@range_use[2][1])
            return geradengleichung([@range_use[2][0],0.2397],[@range_use[3][0],0.42],zvE)
        elsif zvE.between?(@range_use[3][0],@range_use[3][1])
            return 0.42
        elsif zvE.between?(@range_use[4][0],@range_use[4][1]) #very  large number
            return 0.45
        end
    end

    def splitting=(flag)
        @flag = flag
        @flag ? @range_use = @range_split : @range_use = @range_std
    end

    #Berechnet die zu zahlende Einkommensteuer aus dem
    # gegebenen zu versteuernden Einkommen (zvE)
    # Beispiele:
    def ek_steuer(zvE)
        return if !checkNumeric(zvE)
        return 0 if zvE < 1
        zvE = zvE.to_f.round(0)
        if zvE.between?(@range_use[0][0],@range_use[0][1])
            return 0
        elsif zvE.between?(@range_use[1][0],@range_use[1][1])
            return (0.14 * (zvE - @range_use[1][0]) + (zvE - @range_use[1][0]).pow(2) * (((972.87*10.pow(-8))).round(2)/(@flag ? 2:1)))
        elsif zvE.between?(@range_use[2][0],@range_use[2][1])
            return (0.2397 * (zvE - 9409) + (zvE - 9409).pow(2) * (((212.02*10.pow(-8))).round(2)/(@flag ? 2:1)))
        elsif zvE.between?(@range_use[3][0],@range_use[3][1])
            return (0.42 * zvE - 8963.74).round(2)
        elsif zvE.between?(@range_use[4][0],@range_use[4][1]) #very  large number
            return (0.45 * zvE - 17078.74).round(2)
        end
    end

    private def checkNumeric(input)
        if !input.is_a? Numeric
            puts input + " is a " + input.class.to_s
           return false
        end
        return true
    end

    # Berechnet das y einer Geradengleichung für das 
    # jeweilige Einkommen
    private def geradengleichung(pt1,pt2,zvE)
        m = (pt2[1] - pt1[1] ) / (pt2[0] - pt1[0])
        b = pt2[1] - m * pt2[0]
        return (m * zvE + b).round(5)
    end

end
#Erweiterung der Array-Klasse von https://stackoverflow.com/a/68214985/12897392
class Array
    def to_table(header: true)
      column_sizes = self.reduce([]) do |lengths, row|
        row.each_with_index.map{|iterand, index| [lengths[index] || 0, iterand.to_s.length].max}
      end
      head = '+' + column_sizes.map{|column_size| '-' * (column_size + 2) }.join('+') + '+'
      puts head
  
      to_print = self.clone
      if (header == true)
        header = to_print.shift
        print_table_data_row(column_sizes, header)
        puts head
      end
      to_print.each{ |row| print_table_data_row(column_sizes, row) }
      puts head
    end
  
    private
    def print_table_data_row(column_sizes, row)
      row = row.fill(nil, row.size..(column_sizes.size - 1))
      row = row.each_with_index.map{|v, i| v = v.to_s + ' ' * (column_sizes[i] - v.to_s.length)}
      puts '| ' + row.join(' | ') + ' |'
    end
  end

def usuage
    puts "Usuage: ruby 00-eksteuer.rb <val> - \t\t\tAusgabe von Grenzsteuersatz sowie Einkommenssteuer für <val>
            \n\truby 00-eksteuer.rb <val1> <val2> - \t\tAusgabe von Grenzsteuersatz sowie Einkommenssteuer für <val1> und <val2>
            \n\truby 00-eksteuer.rb <val1> <val2> <step> - \tAusgabe von Grenzsteuersatz sowie Einkommenssteuer für <val1> und <val2> in increments von <step>
            "
end

e = Einkommen.new()

for i in 0..ARGV.length
    if(ARGV[i]=='-s')
        e.splitting = true
        ARGV.delete_at(i)
    end
end

data = [['zvE','Grenzsteuersatz','Einkommenssteuer']]
case ARGV.length
when 0
    usuage()
when 1
    zve = ARGV[0].to_f
    data.append([zve.to_i,(e.grenzsteuersatz(zve)*100).to_s + "%",e.ek_steuer(zve).to_s + "€"])
    data.to_table
when 2
    zv1 = ARGV[0].to_f
    zv2 = ARGV[1].to_f
    data.append([zv1.to_i,(e.grenzsteuersatz(zv1)*100).to_s + "%",e.ek_steuer(zv1).to_s + "€"])
    data.append([zv2.to_i,(e.grenzsteuersatz(zv2)*100).to_s + "%",e.ek_steuer(zv2).to_s + "€"])
    data.to_table
when 3
    zv1 = ARGV[0].to_f
    zv2 = ARGV[1].to_f
    step = ARGV[2].to_i
    i = zv1
    while i <=zv2 
        data.append([i.to_i,(e.grenzsteuersatz(i)*100).to_s + "%",e.ek_steuer(i).to_s + "€"])
        i += step
    end
    data.to_table
else
    usuage()
end
=begin
puts "Werbungskosten-Aufgabe"
werbungs = [['zvE','Grenzsteuersatz','Einkommenssteuer', 'gesenktes zvE','gesenkter Grenzsteuersatz', 
'gesenkte Einkommenssteuer']]

werbungs.append([5000,e.grenzsteuersatz(5000),e.ek_steuer(5000),
(5000-2000),e.grenzsteuersatz(5000-2000),e.ek_steuer(5000-2000)])

werbungs.append([10000,e.grenzsteuersatz(10000),e.ek_steuer(10000),
(10000-2000),e.grenzsteuersatz(10000-2000),e.ek_steuer(10000-2000)])

werbungs.append([20000,e.grenzsteuersatz(20000),e.ek_steuer(20000),
(20000-2000),e.grenzsteuersatz(20000-2000),e.ek_steuer(20000-2000)])

werbungs.append([50000,e.grenzsteuersatz(50000),e.ek_steuer(50000),
(50000-2000),e.grenzsteuersatz(50000-2000),e.ek_steuer(50000-2000)])

werbungs.to_table
=end