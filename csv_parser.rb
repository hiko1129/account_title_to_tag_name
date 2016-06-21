require 'csv'
require 'pp'

Dir.chdir('./assets')

temp_data = CSV.read('01_d1.csv')
bs_data, pl_data, cf_data = nil, nil, nil
financial_statements = { bs: '貸借対照表', pl: '損益計算書', cf: 'キャッシュ・フロー計算書'}

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
  if comparison_title == financial_statements[:bs]
    bs_data = create_data(temp_data, i)
  end

  if comparison_title == financial_statements[:pl]
    pl_data = create_data(temp_data, i)
  end


  if comparison_title == financial_statements[:cf]
    cf_data = create_data(temp_data, i)
  end

end

key_array = []
bs_data.each_key do |key|
  key_array << key
end

puts '勘定科目名を入力してください。'
input_string = gets.chomp
def answer(input_data, input_string, key_array)
  q_list =  input_data[key_array[1]].find_all { |n| n.match(input_string) }
  a_list = []
  q_list.each do |i|
    a_list << input_data[key_array[14]][input_data[key_array[1]].index(i)]
  end
  qa_list = Hash[*([q_list, a_list].transpose.flatten)]
  qa_list
end

pp answer(bs_data, input_string, key_array)
pp answer(pl_data, input_string, key_array)
pp answer(cf_data, input_string, key_array)
