require 'csv'
require 'pp'

Dir.chdir('./assets')
puts Dir.pwd

*temp = CSV.read('01_d1.csv')
bs_header, pl_header, cf_header = nil, nil, nil

bs_data = {}
pl_data = {}
cf_data = {}

temp.size.times do |i|

  if temp[i][0] == '貸借対照表'
    bs_header = temp[i + 1]
    bs_header.size.times do |j|
      head = bs_header[j]
      bs_data[head] = []
      row_num = i + 2
      until temp[row_num].nil? || temp[row_num][j].nil?
        bs_data[head] << temp[row_num][j]
        row_num += 1
      end
    end
  end

  if temp[i][0] == '損益計算書'
    pl_header = temp[i + 1]
    pl_header.size.times do |j|
      head = pl_header[j]
      pl_data[head] = []
      row_num = i + 2
      until temp[row_num].nil? || temp[row_num][j].nil?
        pl_data[head] << temp[row_num][j]
        row_num += 1
      end
    end
  end


  if temp[i][0] == 'キャッシュ・フロー計算書'
    cf_header = temp[i + 1]
    cf_header.size.times do |j|
      head = cf_header[j]
      cf_data[head] = []
      row_num = i + 2
      until temp[row_num].nil? || temp[row_num][j].nil?
        cf_data[head] << temp[row_num][j]
        row_num += 1
      end
    end
  end

end

# p bs_header
# p pl_header
# p cf_header
#
# bs_data.each do |key, value|
#   puts key
# end
# pp bs_data['標準ラベル（日本語）']
# pp cf_data['標準ラベル（日本語）']
# Dir.glob('*.csv').count.times do |i|
#   p CSV.read('01_d1.csv')
# end
