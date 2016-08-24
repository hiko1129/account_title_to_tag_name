require 'csv'
require 'pp'

# 投資信託受益証券の検索ができていない。固定資産の検索時に発生。
# TODO 一部修正する。
# XBRL上での業種
type_of_industry = [
  '一般商工業',
  '建設業',
  '銀行・信託業',
  '銀行・信託業（特定取引勘定設置銀行）',
  '建設保証業',
  '第一種金融商品取引業',
  '生命保険業',
  '損害保険業',
  '鉄道事業',
  '海運事業',
  '高速道路事業',
  '電気通信事業',
  '電気事業',
  'ガス事業',
  '資産流動化業',
  '投資運用業',
  '投資業',
  '特定金融業',
  '社会医療法人',
  '学校法人',
  '商品先物取引業',
  'リース事業'
]

# headerをキーとしたHashを返す、値にはデータの配列を格納
def create_data(input_data, input_num)
  output_data = {} # 戻り値
  header = input_data[input_num + 1] # ヘッダー部分（Hashのキー）
  header.size.times do |j|
    head = header[j] # headerの個々のデータ
    output_data[head] = []
    row_num = input_num + 2
    # headerに対する列を格納 exp. 標準ラベルをキー、実データの勘定科目全体の配列をバリューとしてHashに格納
    until input_data[row_num].nil? || input_data[row_num][j].nil?
      output_data[head] << input_data[row_num][j]
      row_num += 1
    end
  end
  output_data
end

# 勘定科目をキー、タグ名を値としたハッシュを返す
def answer(input_data, input_string, key_array)
  unless input_data.nil?
    q_list =  input_data[key_array[1]].find_all { |n| n.match(input_string) }
  else
    q_list = []
  end
  unless q_list.empty?
    a_list = []
    q_list.each do |i|
      a_list << input_data[key_array[14]][input_data[key_array[1]].index(i)]
    end
    qa_list = Hash[*([q_list, a_list].transpose.flatten)]
  else
    qa_list = {}
  end
  qa_list
end


Dir.chdir('./assets')
financial_statements = { bs: '貸借対照表', pl: '損益計算書', cf: 'キャッシュ・フロー計算書'}

puts '勘定科目名を入力してください。'
input_string = gets.chomp

(1..type_of_industry.size).each do  |file_number|
  temp_data = CSV.read("01_d#{file_number}.csv")
  bs_data, pl_data, cf_data = nil, nil, nil

  temp_data.size.times do |i|
    comparison_title = temp_data[i][0]

    # 貸借対照表の場合
    if !comparison_title.nil? && comparison_title.include?(financial_statements[:bs])
      bs_data = create_data(temp_data, i)
    end

    # 損益計算書の場合
    if !comparison_title.nil? && comparison_title.include?(financial_statements[:pl])
      pl_data = create_data(temp_data, i)
    end

    # キャッシュ・フロー計算書の場合
    if !comparison_title.nil? && comparison_title.include?(financial_statements[:cf])
      cf_data = create_data(temp_data, i)
    end
  end


  key_array = []
  bs_data.each_key do |key|
    key_array << key
  end

  bs_answer = answer(bs_data, input_string, key_array)
  pl_answer = answer(pl_data, input_string, key_array)
  cf_answer = answer(cf_data, input_string, key_array)

  bs_flag, pl_flag, cf_flag = false, false, false

  bs_flag = true if bs_answer.empty?
  pl_flag = true if pl_answer.empty?
  cf_flag = true if cf_answer.empty?

  # 業種、勘定科目、タグ名を表示
  puts "# #{type_of_industry[file_number - 1]}" unless bs_flag && pl_flag && cf_flag
  pp bs_answer unless bs_flag
  puts
  pp pl_answer unless pl_flag
  puts
  pp cf_answer unless cf_flag
  puts
end
