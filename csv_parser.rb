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
      bs_data[bs_header[j]] = []
      row_num = i + 2
      while temp[row_num][j] != nil
        bs_data[bs_header[j]] << temp[row_num][j]
        row_num += 1
      end
    end
  end

  if temp[i][0] == '損益計算書'
    pl_header = temp[i + 1]
  end

  if temp[i][0] == 'キャッシュ・フロー計算書'
    cf_header = temp[i + 1]
  end

end

p bs_header
p pl_header
p cf_header

bs_data.each do |key, value|
  puts key
end
pp bs_data['標準ラベル（日本語）']
# Dir.glob('*.csv').count.times do |i|
#   p CSV.read('01_d1.csv')
# end
