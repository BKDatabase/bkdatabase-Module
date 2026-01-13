--- SEO, là một mô đun cho phép chèn các metadata SEO tự động vào các bài viết trên BKDatabase qua sự hỗ trợ của phần mở rộng [[mw:Extension:WikiSEO|WikiSEO]].
-- Thường không được nhúng trực tiếp, trừ khi bất khả kháng như không có infobox hoặc trang đặc biệt.
-- '''Lưu ý''': Dùng mô đun này giới hạn ở không gian tên chính, Lore, Thành viên, Thể loại hoặc Timeline.
--  @module             SEO
--  @alias              WikiSEO
--  @author             [[m:User:Pisces|Song Ngư.xyz]] (Bản gốc ở 100bangaiwiki)
--  @author             [[User:Bapham123|The Great Trial Await...]] (người phái sinh)
--  @script             Module:SEO
--  @release            p
-- <nowiki>
local seo = {}

-- Apply SEO metadata for the current page using the WikiSEO (WikiSEO) extension.
-- If the current page is the homepage (title "Trang Chính"), replace the page title and use a fixed description, banner image, and image alt text.
-- @return The HTML comment <!-- Metadata SEO cố định --> indicating the module ran.
function seo.main(frame)
  local titleObj = mw.title.getCurrentTitle()
  local siteName = mw.site.siteName
  local pageTitle = titleObj.prefixedText .. " – " .. siteName

  local keywords = {
    -- Từ khóa dự án
  "Blutiges Kareuz", "BKDatabase", "Blutiges Kareuz: The Decline of the Millennium", "Blutiges Kareuz: The Decline of the Millennium | Database",
  "Blutiges Kareuz Database", "BK", "BlutigesKreuz",
    -- Từ khóa nền tảng
    "wiki", "miraheze", "miraheze wikis", "wiki Alternate History", "dự án ghi chép", "dự án cá nhân", "Wikitide",
    -- Từ khóa bài viết
    titleObj.text, titleObj.prefixedText
  }

  local seoTable = {
    title = pageTitle,
    keywords = table.concat(keywords, ", "),
    site_name = siteName,
    image = titleObj.pageImage
  }

  if titleObj.text == "Trang Chính" then
    seoTable.title_mode = "replace"
    seoTable.title = siteName
    seoTable.description = 'Vào năm 1919, thập tự sắt đã bắt đầu nhuốm máu...'
    seoTable.image = '8ff2ea6f-ee50-4f8a-b0c1-de497ea7e95b.png'
    seoTable.image_alt = 'Banner chính của wiki'
  end

  mw.ext.seo.set(seoTable)
  return "<!-- Metadata SEO cố định -->"
end

-- Applies SEO metadata by delegating to the WikiSEO extension.
-- @param argTable Table of SEO fields accepted by mw.ext.seo.set (for example: `title`, `description`, `keywords`, `site_name`, `image`, `image_alt`, `title_mode`).
function seo.set(argTable)
  mw.ext.seo.set(argTable)
end

return seo