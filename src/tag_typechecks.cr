require "./attr_enums/*"

module ToHtml
  module TagTypechecks
    extend self

    def a_typecheck(rel : (AttrEnums::AnchorRel | String | Nil) = nil, **args)
      args.merge(rel: rel)
    end

    def abbr_typecheck(**args)
      args
    end

    def address_typecheck(**args)
      args
    end

    def article_typecheck(**args)
      args
    end

    def aside_typecheck(**args)
      args
    end

    def audio_typecheck(**args)
      args
    end

    def b_typecheck(**args)
      args
    end

    def bdi_typecheck(**args)
      args
    end

    def bdo_typecheck(**args)
      args
    end

    def blockquote_typecheck(**args)
      args
    end

    def body_typecheck(**args)
      args
    end

    def button_typecheck(**args)
      args
    end

    def canvas_typecheck(**args)
      args
    end

    def caption_typecheck(**args)
      args
    end

    def cite_typecheck(**args)
      args
    end

    def code_typecheck(**args)
      args
    end

    def colgroup_typecheck(**args)
      args
    end

    def data_typecheck(**args)
      args
    end

    def datalist_typecheck(**args)
      args
    end

    def dd_typecheck(**args)
      args
    end

    def del_typecheck(**args)
      args
    end

    def details_typecheck(**args)
      args
    end

    def dfn_typecheck(**args)
      args
    end

    def dialog_typecheck(**args)
      args
    end

    def div_typecheck(**args)
      args
    end

    def dl_typecheck(**args)
      args
    end

    def dt_typecheck(**args)
      args
    end

    def em_typecheck(**args)
      args
    end

    def fieldset_typecheck(**args)
      args
    end

    def figcaption_typecheck(**args)
      args
    end

    def figure_typecheck(**args)
      args
    end

    def footer_typecheck(**args)
      args
    end

    def form_typecheck(method : (AttrEnums::FormMethod | String | Nil) = nil, **args)
      args.merge(method: method)
    end

    def h1_typecheck(**args)
      args
    end

    def h2_typecheck(**args)
      args
    end

    def h3_typecheck(**args)
      args
    end

    def h4_typecheck(**args)
      args
    end

    def h5_typecheck(**args)
      args
    end

    def h6_typecheck(**args)
      args
    end

    def head_typecheck(**args)
      args
    end

    def header_typecheck(**args)
      args
    end

    def html_typecheck(**args)
      args
    end

    def i_typecheck(**args)
      args
    end

    def iframe_typecheck(**args)
      args
    end

    def ins_typecheck(**args)
      args
    end

    def kbd_typecheck(**args)
      args
    end

    def label_typecheck(**args)
      args
    end

    def legend_typecheck(**args)
      args
    end

    def li_typecheck(**args)
      args
    end

    def main_typecheck(**args)
      args
    end

    def map_typecheck(**args)
      args
    end

    def mark_typecheck(**args)
      args
    end

    def menu_typecheck(**args)
      args
    end

    def meter_typecheck(**args)
      args
    end

    def nav_typecheck(**args)
      args
    end

    def noscript_typecheck(**args)
      args
    end

    def object_typecheck(**args)
      args
    end

    def ol_typecheck(**args)
      args
    end

    def optgroup_typecheck(**args)
      args
    end

    def option_typecheck(**args)
      args
    end

    def output_typecheck(**args)
      args
    end

    def p_typecheck(**args)
      args
    end

    def picture_typecheck(**args)
      args
    end

    def pre_typecheck(**args)
      args
    end

    def progress_typecheck(**args)
      args
    end

    def q_typecheck(**args)
      args
    end

    def rp_typecheck(**args)
      args
    end

    def rt_typecheck(**args)
      args
    end

    def ruby_typecheck(**args)
      args
    end

    def s_typecheck(**args)
      args
    end

    def samp_typecheck(**args)
      args
    end

    def script_typecheck(**args)
      args
    end

    def section_typecheck(**args)
      args
    end

    def select_tag_typecheck(**args)
      args
    end

    def small_typecheck(**args)
      args
    end

    def span_typecheck(**args)
      args
    end

    def strong_typecheck(**args)
      args
    end

    def style_typecheck(**args)
      args
    end

    def sub_typecheck(**args)
      args
    end

    def summary_typecheck(**args)
      args
    end

    def sup_typecheck(**args)
      args
    end

    def svg_typecheck(**args)
      args
    end

    def table_typecheck(**args)
      args
    end

    def tbody_typecheck(**args)
      args
    end

    def td_typecheck(**args)
      args
    end

    def template_typecheck(**args)
      args
    end

    def textarea_typecheck(**args)
      args
    end

    def tfoot_typecheck(**args)
      args
    end

    def th_typecheck(**args)
      args
    end

    def thead_typecheck(**args)
      args
    end

    def time_typecheck(**args)
      args
    end

    def title_typecheck(**args)
      args
    end

    def tr_typecheck(**args)
      args
    end

    def u_typecheck(**args)
      args
    end

    def ul_typecheck(**args)
      args
    end

    def var_typecheck(**args)
      args
    end

    def video_typecheck(**args)
      args
    end

    def area_typecheck(**args)
      args
    end

    def base_typecheck(**args)
      args
    end

    def br_typecheck(**args)
      args
    end

    def col_typecheck(**args)
      args
    end

    def embed_typecheck(**args)
      args
    end

    def hr_typecheck(**args)
      args
    end

    def img_typecheck(**args)
      args
    end

    def input_typecheck(type : (AttrEnums::InputType | String | Nil) = nil, **args)
      args.merge(type: type)
    end

    def link_typecheck(**args)
      args
    end

    def meta_typecheck(name : (AttrEnums::MetaName | String | Nil) = nil, **args)
      args.merge(name: name)
    end

    def param_typecheck(**args)
      args
    end

    def source_typecheck(**args)
      args
    end

    def track_typecheck(**args)
      args
    end

    def wbr_typecheck(**args)
      args
    end
  end
end
