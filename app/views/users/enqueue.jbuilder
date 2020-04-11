  json.id 		@queue_slot.merchant.id
  json.name 		@queue_slot.merchant.name
  json.join_code	@queue_slot.merchant.join_code
  json.length		@queue_slot.merchant.owned_queue_slots.count
  json.pq_len		@queue_slot.merchant.qlength
  json.position		@queue_slot.position
