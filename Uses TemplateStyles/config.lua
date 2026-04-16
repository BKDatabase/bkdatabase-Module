local cfg = {} -- Don’t touch this line.

-- Subpage blacklist: these subpages will not be categorized (except for the
-- error category, which is always added if there is an error).
-- For example “Template:Foo/doc” matches the `doc = true` rule, so it will have
-- no categories. “Template:Foo” and “Template:Foo/documentation” match no rules,
-- so they *will* have categories. All rules should be in the
--   ['<subpage name>'] = true,
-- format.
cfg['subpage_blacklist'] = {
	['doc'] = true,
	['sandbox'] = true,
	['sandbox2'] = true,
	['testcases'] = true,
}

-- Sandbox title: if the stylesheet’s title is <template>/<stylesheet>.css, the
-- stylesheet’s sandbox is expected to be at <template>/<sandbox_title>/<stylesheet>.css
-- Set to nil to disable sandbox links.
cfg['sandbox_title'] = 'sandbox'

-- Error category: this category is added if the module call contains errors
-- (e.g. no stylesheet listed). A category name without namespace, or nil
-- to disable categorization (not recommended).
cfg['error_category'] = 'Bản mẫu Uses TemplateStyles có lỗi'

-- Default category: this category is added if no custom category is specified
-- in module/template call. A category name without namespace, or nil
-- to disable categorization.
cfg['default_category'] = 'Bản mẫu sử dụng TemplateStyles'

-- Protection conflict category: this category is added if the protection level
-- of any stylesheet is lower than the protection level of the template. A category name
-- without namespace, or nil to disable categorization (not recommended).
cfg['protection_conflict_category'] = 'Bản mẫu sử dụng TemplateStyles có mức khóa khác nhau'

-- Hierarchy of protection levels, used to determine whether one protection level is lower
-- than another and thus should populate protection_conflict_category. No protection is treated as zero 
cfg['protection_hierarchy']  = {
	autoconfirmed = 1,
	extendedconfirmed = 2,
	templateeditor = 3,
	sysop = 4
}

-- Padlock pattern: Lua pattern to search on protected stylesheets for, or nil
-- to disable padlock check.
cfg['padlock_pattern'] = '{{pp-'

-- Missing padlock category: this category is added if a protected stylesheet
-- doesn’t contain any padlock template (specified by the above Lua pattern).
-- A category name without namespace (no nil allowed) if the pattern is not nil,
-- unused (and thus may be nil) otherwise.
cfg['missing_padlock_category'] = 'Bản mẫu sử dụng TemplateStyles không khoá'

-- Default subpage for the stylesheet if none is given
cfg['default_subpage_name'] = 'styles.css'
return cfg -- Don’t touch this line.
