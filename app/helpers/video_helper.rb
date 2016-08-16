module VideoHelper

  def youtube_duration_video(code)
    duration_time = Yt::Video.new id: "#{code}"

    Time.at(duration_time.duration).utc.strftime("%M:%S")
  end

  def youtube_small_thumbnail(code)
    video = Yt::Video.new id: "#{code}"

    video.thumbnail_url
  end

  def youtube_medium_thumbnail(code)
    youtube_small_thumbnail(code).gsub!('default', 'mqdefault')
  end

  def youtube_large_thumbnail(code)
    youtube_small_thumbnail(code).gsub!('default', 'hqdefault')
  end

end
