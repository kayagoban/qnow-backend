json.array! @merchant_joins do |mjoin|
  json.id 		mjoin.merchant.id
  json.q_len		mjoin.merchant.queue_slots_count
  json.pos		mjoin.position 
  json.pq_len		mjoin.merchant.qlength
end
