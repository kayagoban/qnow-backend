json.array! @user.known_merchants do |merchant|
  json.id 		merchant.id
  json.name 		merchant.name
  json.length		merchant.owned_queue_slots.count
  json.pq_len		merchant.qlength
end
