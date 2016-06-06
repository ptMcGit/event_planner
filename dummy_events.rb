# test events

def valid_future_date max_days_out=12, min_secs_out=1800
  current_block = Time.now - (Time.now.tv_sec % 1800)
  future_blocks = (min_secs_out..(86400 * max_days_out)).step(1800).to_a

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

In_one_day_event =
  {
    title: "My event that happens less than day",
    date: valid_future_date(1, 3600),
    zip_code: "64575",
    duration_sec: "5400"
  }

In_two_days_event =
  {
    title: "My 1 < event < 3 days.",
    date: valid_future_date(3, 3600 * 24),
    zip_code: "64575",
    duration_sec: "5400"
  }
