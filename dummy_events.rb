# test events

def valid_future_date
  current_block = Time.now - (Time.now.tv_sec % 1800)
  max_days_out = 12
  future_blocks = (1800..(86400 * max_days_out)).step(1800).to_a

  Time.at(
    current_block +
    future_blocks.sample
  ).tv_sec.to_s
end

Socal_reggae =
   {
     title: "Reggae Sunsplash",
     date: valid_future_date,
     zip_code: "90210",
     duration_sec: "3600"
   }

Rainy_birthday =
    {
      title: "Bob birthday",
      date: valid_future_date,
      zip_code: "98101",
      duration_sec: "1800"
    }

Expired_date_event =
    {
      title: "My forty-second birthday",
      date: "1991-04-12",
      zip_code: "27401",
      duration_sec: "1800"
    }
