require 'rails_helper'

 RSpec.describe 'Cart', type: :system do

   let!(:user){ create(:user) }
   let!(:product1){ create(:product, name: "米",         price: 1000) }
   let!(:product2){ create(:product, name: "ルー",        price: 2000) }
   let!(:product3){ create(:product, name: "カレーライス", price: 3000) }

  scenario 'user logins, edits cart, and purchases' do
    visit root_path
    click_link 'ログイン'
    fill_in with: user.email, id: 'user_email'
    fill_in with: "hogehoge", id: 'user_password'
    click_button 'ログイン'

    expect(page).to have_current_path(user_root_path)
    expect(page).to have_content 'ログインしました'
    expect(page).to have_content 'ログアウト'

    click_link 'ショッピングカート'

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートは空です'

    #--------------------
    # 商品追加 1
    #--------------------
    click_link 'お買い物'

    expect(page).to have_current_path(products_path)
    expect(page).to have_content "米"
    expect(page).to have_content "ルー"
    expect(page).to have_content "カレーライス"

    click_link "米"

    expect(page).to have_current_path(new_product_cart_product_path(product1))

    fill_in with: 11, id: 'purchase_product_num'
    click_on "ショッピングカートに入れる"

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートに保存しました'
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b11,000円\b/ # 小径
      expect(page).to have_content  /\b1,800円\b/ # 送料
      expect(page).to have_content    /\b400円\b/ # 代引き手数料
      expect(page).to have_content  /\b1,056円\b/ # 消費税
      expect(page).to have_content /\b14,256円\b/ # 合計
    end

    #--------------------
    # 商品追加 2
    #--------------------
    click_link 'お買い物'

    expect(page).to have_current_path(products_path)
    click_link "ルー"

    fill_in with: 22, id: 'purchase_product_num'
    click_on "ショッピングカートに入れる"

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートに保存しました'
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    within("#product_#{product2.id}") do
      expect(page).to have_content "ルー"
      expect(page).to have_content /\b2,000円\b/
      expect(page).to have_content /\b22\b/
      expect(page).to have_content /\b44,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b55,000円\b/ # 小径
      expect(page).to have_content  /\b4,200円\b/ # 送料
      expect(page).to have_content    /\b600円\b/ # 代引き手数料
      expect(page).to have_content  /\b4,784円\b/ # 消費税
      expect(page).to have_content /\b64,584円\b/ # 合計
    end

    #--------------------
    # 商品追加 3
    #--------------------
    click_link 'お買い物'

    expect(page).to have_current_path(products_path)

    click_link "カレーライス"

    fill_in with: 33, id: 'purchase_product_num'
    click_on "ショッピングカートに入れる"

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートに保存しました'
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    within("#product_#{product2.id}") do
      expect(page).to have_content "ルー"
      expect(page).to have_content /\b2,000円\b/
      expect(page).to have_content /\b22\b/
      expect(page).to have_content /\b44,000円\b/
    end
    within("#product_#{product3.id}") do
      expect(page).to have_content "カレーライス"
      expect(page).to have_content /\b3,000円\b/
      expect(page).to have_content /\b33\b/
      expect(page).to have_content /\b99,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b154,000円\b/ # 小径
      expect(page).to have_content   /\b8,400円\b/ # 送料
      expect(page).to have_content   /\b1,000円\b/ # 代引き手数料
      expect(page).to have_content  /\b13,072円\b/ # 消費税
      expect(page).to have_content /\b176,472円\b/ # 合計
    end

    #--------------------
    # 数量変更
    #--------------------
    within("#product_#{product1.id}") do
      click_link "変更"
      fill_in with:10, name: 'purchase_product[num]'
      click_on "更新"
    end

    expect(page).to have_selector ".alert-info", text: '更新しました'
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b10\b/
      expect(page).to have_content /\b10,000円\b/
    end
    within("#product_#{product2.id}") do
      expect(page).to have_content "ルー"
      expect(page).to have_content /\b2,000円\b/
      expect(page).to have_content /\b22\b/
      expect(page).to have_content /\b44,000円\b/
    end
    within("#product_#{product3.id}") do
      expect(page).to have_content "カレーライス"
      expect(page).to have_content /\b3,000円\b/
      expect(page).to have_content /\b33\b/
      expect(page).to have_content /\b99,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b153,000円\b/ # 小径
      expect(page).to have_content   /\b7,800円\b/ # 送料
      expect(page).to have_content   /\b1,000円\b/ # 代引き手数料
      expect(page).to have_content  /\b12,944円\b/ # 消費税
      expect(page).to have_content /\b174,744円\b/ # 合計
    end

    #--------------------
    # 商品追加 4
    #--------------------
    click_link 'お買い物'

    expect(page).to have_current_path(products_path)

    click_link "米"

    fill_in with: 1, id: 'purchase_product_num'
    click_on "ショッピングカートに入れる"

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートに保存しました'
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    within("#product_#{product2.id}") do
      expect(page).to have_content "ルー"
      expect(page).to have_content /\b2,000円\b/
      expect(page).to have_content /\b22\b/
      expect(page).to have_content /\b44,000円\b/
    end
    within("#product_#{product3.id}") do
      expect(page).to have_content "カレーライス"
      expect(page).to have_content /\b3,000円\b/
      expect(page).to have_content /\b33\b/
      expect(page).to have_content /\b99,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b154,000円\b/ # 小径
      expect(page).to have_content   /\b8,400円\b/ # 送料
      expect(page).to have_content   /\b1,000円\b/ # 代引き手数料
      expect(page).to have_content  /\b13,072円\b/ # 消費税
      expect(page).to have_content /\b176,472円\b/ # 合計
    end

    #--------------------
    # 商品削除
    #--------------------
    within("#product_#{product2.id}") do
      click_link "削除"
    end
    expect(page).to have_selector ".alert-info", text: "削除しました"
    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    expect(page).not_to have_selector "#product_#{product2.id}"
    within("#product_#{product3.id}") do
      expect(page).to have_content "カレーライス"
      expect(page).to have_content /\b3,000円\b/
      expect(page).to have_content /\b33\b/
      expect(page).to have_content /\b99,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b110,000円\b/ # 小径
      expect(page).to have_content   /\b5,400円\b/ # 送料
      expect(page).to have_content   /\b1,000円\b/ # 代引き手数料
      expect(page).to have_content   /\b9,312円\b/ # 消費税
      expect(page).to have_content /\b125,712円\b/ # 合計
    end

    #--------------------
    # 送付先情報
    #--------------------
    click_on "送付先情報の編集画面に進む"

    expect(page).to have_current_path(edit_shipping_address_cart_path)
    expect(page).to have_content "送付先情報の編集"
    expect(page).to have_field(id: 'cart_shipping_address_attributes_name', with: '')
    expect(page).to have_field(id: 'cart_shipping_address_attributes_postal_code', with: '')
    expect(page).to have_field(id: 'cart_shipping_address_attributes_prefecture', with: '')
    expect(page).to have_field(id: 'cart_shipping_address_attributes_city', with: '')
    expect(page).to have_field(id: 'cart_shipping_address_attributes_address', with: '')
    expect(page).to have_field(id: 'cart_shipping_address_attributes_building', with: '')
    expect(page).to have_field(id: 'cart_save_shipping_address', checked: true)
    expect(page).to have_select(id: 'cart_delivery_scheduled_date', selected: '')
    expect(page).to have_select(id: 'cart_delivery_scheduled_time', selected: '')

    click_on "確認画面に進む"

    expect(page).to have_content('氏名を入力してください')
    expect(page).to have_content('郵便番号を入力してください')
    expect(page).to have_content('都道府県を入力してください')
    expect(page).to have_content('市町村を入力してください')
    expect(page).to have_content('その他住所を入力してください')

    fill_in id: 'cart_shipping_address_attributes_name', with: "山田太郎"
    fill_in id: 'cart_shipping_address_attributes_postal_code', with: "123-4567"
    fill_in id: 'cart_shipping_address_attributes_prefecture', with: "石川県"
    fill_in id: 'cart_shipping_address_attributes_city', with: "金沢市"
    fill_in id: 'cart_shipping_address_attributes_address', with: "もりの里2-723-24"
    fill_in id: 'cart_shipping_address_attributes_building', with: "パークハイムハイツもりの里1203"
    select "2019-01-18", from: "cart_delivery_scheduled_date"
    select "14:00-16:00", from: "cart_delivery_scheduled_time"

    #--------------------
    # 確認画面
    #--------------------
    click_on "確認画面に進む"

    expect(page).to have_current_path(cart_path)
    expect(page).to have_content "ショッピングカートの確認"

    within("#product_#{product1.id}") do
      expect(page).to have_content "米"
      expect(page).to have_content /\b1,000円\b/
      expect(page).to have_content /\b11\b/
      expect(page).to have_content /\b11,000円\b/
    end
    expect(page).not_to have_selector "#product_#{product2.id}"
    within("#product_#{product3.id}") do
      expect(page).to have_content "カレーライス"
      expect(page).to have_content /\b3,000円\b/
      expect(page).to have_content /\b33\b/
      expect(page).to have_content /\b99,000円\b/
    end
    within("tfoot") do
      expect(page).to have_content /\b110,000円\b/ # 小径
      expect(page).to have_content   /\b5,400円\b/ # 送料
      expect(page).to have_content   /\b1,000円\b/ # 代引き手数料
      expect(page).to have_content   /\b9,312円\b/ # 消費税
      expect(page).to have_content /\b125,712円\b/ # 合計
    end
    expect(page).to have_content('123-4567 石川県 金沢市もりの里2-723-24 パークハイムハイツもりの里1203')
    expect(page).to have_content('山田太郎')
    expect(page).to have_content('2019-01-18')
    expect(page).to have_content('14:00-16:00')

    #--------------------
    # 確定
    #--------------------
    click_on "確定"

    expect(page).to have_current_path(show_complete_cart_path)
    expect(page).to have_content "ご購入ありがとうございました"

    #--------------------
    # ショッピングカート
    #--------------------
    click_link 'ショッピングカート'

    expect(page).to have_current_path(edit_cart_path)
    expect(page).to have_content 'ショッピングカートは空です'

    #--------------------
    # 購入履歴
    #--------------------
    click_link '購入履歴'

    expect(page).to have_current_path(purchase_histories_path)
    expect(page).to have_content '購入履歴の一覧'

    within('table') do
      expect(page).to have_content('米')
      expect(page).to have_content('カレーライス')
      expect(page).to have_content(/\b44\b/)
      expect(page).to have_content(/\b125,712円\b/)
    end
  end
 end
