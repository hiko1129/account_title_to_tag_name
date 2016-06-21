require 'csv'
require 'pp'

Dir.chdir('./assets')

temp_data = CSV.read('01_d1.csv')
bs_header, pl_header, cf_header = nil, nil, nil
bs_data, pl_data, cf_data = nil, nil, nil

def create_data(input_data, input_num)
  output_data = {}
  header = input_data[input_num + 1]
  header.size.times do |j|
    head = header[j]
    output_data[head] = []
    row_num = input_num + 2
    until input_data[row_num].nil? || input_data[row_num][j].nil?
      output_data[head] << input_data[row_num][j]
      row_num += 1
    end
  end
  output_data
end

temp_data.size.times do |i|

  comparison_title = temp_data[i][0]
  if comparison_title == '貸借対照表'
    bs_data = create_data(temp_data, i)
  end

  if comparison_title == '損益計算書'
    pl_data = create_data(temp_data, i)
  end


  if comparison_title == 'キャッシュ・フロー計算書'
    cf_data = create_data(temp_data, i)
  end

end

pl_data.each_key do |key|
  puts key
end
