namespace('kivi.Order', function(ns) {
  ns.check_cv = function() {
    if ($('#type').val() == 'sales_order' || $('#type').val() == 'sales_quotation') {
      if ($('#order_customer_id').val() === '') {
        alert(kivi.t8('Please select a customer.'));
        return false;
      }
    } else  {
      if ($('#order_vendor_id').val() === '') {
        alert(kivi.t8('Please select a vendor.'));
        return false;
      }
    }
    return true;
  };

  ns.check_duplicate_parts = function(question) {
    var id_arr = $('[name="order.orderitems[].parts_id"]').map(function() { return this.value; }).get();

    var i, obj = {}, pos = [];

    for (i = 0; i < id_arr.length; i++) {
      var id = id_arr[i];
      if (obj.hasOwnProperty(id)) {
        pos.push(i + 1);
      }
      obj[id] = 0;
    }

    if (pos.length > 0) {
      question = question || kivi.t8("Do you really want to save?");
      return confirm(kivi.t8("There are duplicate parts at positions") + "\n"
                     + pos.join(', ') + "\n"
                     + question);
    }
    return true;
  };

  ns.check_valid_reqdate = function() {
    if ($('#order_reqdate_as_date').val() === '') {
      alert(kivi.t8('Please select a delivery date.'));
      return false;
    } else {
      return true;
    }
  };

  ns.save = function(action, warn_on_duplicates, warn_on_reqdate) {
    if (!ns.check_cv()) return;
    if (warn_on_duplicates && !ns.check_duplicate_parts()) return;
    if (warn_on_reqdate    && !ns.check_valid_reqdate())   return;

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/' + action });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.delete_order = function() {
    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/delete' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.show_print_options = function(warn_on_duplicates) {
    if (!ns.check_cv()) return;
    if (warn_on_duplicates && !ns.check_duplicate_parts(kivi.t8("Do you really want to print?"))) return;

    kivi.popup_dialog({
      id: 'print_options',
      dialog: {
        title: kivi.t8('Print options'),
        width:  800,
        height: 300
      }
    });
  };

  ns.print = function() {
    $('#print_options').dialog('close');

    var data = $('#order_form').serializeArray();
    data = data.concat($('#print_options_form').serializeArray());
    data.push({ name: 'action', value: 'Order/print' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.download_pdf = function(pdf_filename, key) {
    var data = [{ name: 'action',       value: 'Order/download_pdf' },
                { name: 'type',         value: $('#type').val()     },
                { name: 'pdf_filename', value: pdf_filename         },
                { name: 'key',          value: key                  }];
    $.download("controller.pl", data);
  };

  ns.email = function(warn_on_duplicates) {
    if (warn_on_duplicates && !ns.check_duplicate_parts(kivi.t8("Do you really want to send by mail?"))) return;
    if (!ns.check_cv()) return;

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/show_email_dialog' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  var email_dialog;

  ns.setup_send_email_dialog = function() {
    kivi.SalesPurchase.show_all_print_options_elements();
    kivi.SalesPurchase.show_print_options_elements([ 'sendmode', 'media', 'copies', 'remove_draft' ], false);

    $('#print_options_form table').first().remove().appendTo('#email_form_print_options');

    var to_focus = $('#email_form_to').val() === '' ? 'to' : 'subject';
    $('#email_form_' + to_focus).focus();
  };

  ns.finish_send_email_dialog = function() {
    kivi.SalesPurchase.show_all_print_options_elements();

    $('#email_form_print_options table').first().remove().prependTo('#print_options_form');
    return true;
  };

  ns.show_email_dialog = function(html) {
    var id            = 'send_email_dialog';
    var dialog_params = {
      id:     id,
      width:  800,
      height: 600,
      title:  kivi.t8('Send email'),
      modal:  true,
      beforeClose: kivi.Order.finish_send_email_dialog,
      close: function(event, ui) {
        email_dialog.remove();
      }
    };

    $('#' + id).remove();

    email_dialog = $('<div style="display:none" id="' + id + '"></div>').appendTo('body');
    email_dialog.html(html);
    email_dialog.dialog(dialog_params);

    kivi.Order.setup_send_email_dialog();

    $('.cancel').click(ns.close_email_dialog);

    return true;
  };

  ns.send_email = function() {
    var data = $('#order_form').serializeArray();
    data = data.concat($('[name^="email_form."]').serializeArray());
    data = data.concat($('[name^="print_options."]').serializeArray());
    data.push({ name: 'action', value: 'Order/send_email' });
    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.close_email_dialog = function() {
    email_dialog.dialog("close");
  };

  ns.set_number_in_title = function(elt) {
    $('#nr_in_title').html($(elt).val());
  };

  ns.reload_cv_dependant_selections = function() {
    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/customer_vendor_changed' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.reformat_number = function(event) {
    $(event.target).val(kivi.format_amount(kivi.parse_amount($(event.target).val()), -2));
  };

  ns.recalc_amounts_and_taxes = function() {
    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/recalc_amounts_and_taxes' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.unit_change = function(event) {
    var row           = $(event.target).parents("tbody").first();
    var item_id_dom   = $(row).find('[name="orderitem_ids[+]"]');
    var sellprice_dom = $(row).find('[name="order.orderitems[].sellprice_as_number"]');
    var select_elt    = $(row).find('[name="order.orderitems[].unit"]');

    var oldval = $(select_elt).data('oldval');
    $(select_elt).data('oldval', $(select_elt).val());

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action',           value: 'Order/unit_changed'     },
              { name: 'item_id',          value: item_id_dom.val()        },
              { name: 'old_unit',         value: oldval                   },
              { name: 'sellprice_dom_id', value: sellprice_dom.attr('id') });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.update_sellprice = function(item_id, price_str) {
    var row       = $('#item_' + item_id).parents("tbody").first();
    var price_elt = $(row).find('[name="order.orderitems[].sellprice_as_number"]');
    var html_elt  = $(row).find('[name="sellprice_text"]');
    price_elt.val(price_str);
    html_elt.html(price_str);
  };

  ns.load_second_row = function(row) {
    var item_id_dom = $(row).find('[name="orderitem_ids[+]"]');
    var div_elt     = $(row).find('[name="second_row"]');

    if ($(div_elt).data('loaded') == 1) {
      return;
    }
    var data = $('#order_form').serializeArray();
    data.push({ name: 'action',     value: 'Order/load_second_rows' },
              { name: 'item_ids[]', value: item_id_dom.val()        });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.load_all_second_rows = function() {
    var rows = $('.row_entry').filter(function(idx, elt) {
      return $(elt).find('[name="second_row"]').data('loaded') != 1;
    });

    var item_ids = $.map(rows, function(elt) {
      var item_id = $(elt).find('[name="orderitem_ids[+]"]').val();
      return { name: 'item_ids[]', value: item_id };
    });

    if (item_ids.length == 0) {
      return;
    }

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/load_second_rows' });
    data = data.concat(item_ids);

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.hide_second_row = function(row) {
    $(row).children().not(':first').hide();
    $(row).data('expanded', 0);
    var elt = $(row).find('.expand');
    elt.attr('src', "image/expand.svg");
    elt.attr('alt', kivi.t8('Show details'));
    elt.attr('title', kivi.t8('Show details'));
  };

  ns.show_second_row = function(row) {
    $(row).children().not(':first').show();
    $(row).data('expanded', 1);
    var elt = $(row).find('.expand');
    elt.attr('src', "image/collapse.svg");
    elt.attr('alt', kivi.t8('Hide details'));
    elt.attr('title', kivi.t8('Hide details'));
  };

  ns.toggle_second_row = function(row) {
    if ($(row).data('expanded') == 1) {
      ns.hide_second_row(row);
    } else {
      ns.show_second_row(row);
    }
  };

  ns.init_row_handlers = function() {
    kivi.run_once_for('.recalc', 'on_change_recalc', function(elt) {
      $(elt).change(ns.recalc_amounts_and_taxes);
    });

    kivi.run_once_for('.reformat_number', 'on_change_reformat', function(elt) {
      $(elt).change(ns.reformat_number);
    });

    kivi.run_once_for('.unitselect', 'on_change_unit_with_oldval', function(elt) {
      $(elt).data('oldval', $(elt).val());
      $(elt).change(ns.unit_change);
    });

    kivi.run_once_for('.row_entry', 'on_kbd_click_show_hide', function(elt) {
      $(elt).keydown(function(event) {
        var row;
        if (event.keyCode == 40 && event.shiftKey === true) {
          // shift arrow down
          event.preventDefault();
          row = $(event.target).parents(".row_entry").first();
          ns.load_second_row(row);
          ns.show_second_row(row);
          return false;
        }
        if (event.keyCode == 38 && event.shiftKey === true) {
          // shift arrow up
          event.preventDefault();
          row = $(event.target).parents(".row_entry").first();
          ns.hide_second_row(row);
          return false;
        }
      });
    });

    kivi.run_once_for('.expand', 'expand_second_row', function(elt) {
      $(elt).click(function(event) {
        event.preventDefault();
        var row = $(event.target).parents(".row_entry").first();
        ns.load_second_row(row);
        ns.toggle_second_row(row);
        return false;
      })
    });

  };

  ns.redisplay_line_values = function(is_sales, data) {
    $('.row_entry').each(function(idx, elt) {
      $(elt).find('[name="linetotal"]').html(data[idx][0]);
      if (is_sales && $(elt).find('[name="second_row"]').data('loaded') == 1) {
        var mt = data[idx][1];
        var mp = data[idx][2];
        var h  = '<span';
        if (mt[0] === '-') h += ' class="plus0"';
        h += '>' + mt + '&nbsp;&nbsp;' + mp + '%';
        h += '</span>';
        $(elt).find('[name="linemargin"]').html(h);
      }
    });
  };

  ns.renumber_positions = function() {
    $('.row_entry [name="position"]').each(function(idx, elt) {
      $(elt).html(idx+1);
    });
  };

  ns.reorder_items = function(order_by) {
    var dir = $('#' + order_by + '_header_id a img').attr("data-sort-dir");
    $('#row_table_id thead a img').remove();

    var src;
    if (dir == "1") {
      dir = "0";
      src = "image/up.png";
    } else {
      dir = "1";
      src = "image/down.png";
    }

    $('#' + order_by + '_header_id a').append('<img border=0 data-sort-dir=' + dir + ' src=' + src + ' alt="' + kivi.t8('sort items') + '">');

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action',   value: 'Order/reorder_items' },
              { name: 'order_by', value: order_by              },
              { name: 'sort_dir', value: dir                   });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.redisplay_items = function(data) {
    var old_rows = $('.row_entry').detach();
    var new_rows = [];
    $(data).each(function(idx, elt) {
      new_rows.push(old_rows[elt.old_pos - 1]);
    });
    $(new_rows).appendTo($('#row_table_id'));
    ns.renumber_positions();
  };

  ns.add_item = function() {
    if ($('#add_item_parts_id').val() === '') return;
    if (!ns.check_cv()) return;

    $('#row_table_id thead a img').remove();

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action', value: 'Order/add_item' });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.setup_multi_items_dialog = function() {
    $('#multi_items_filter_table input, #multi_items_filter_table select').keydown(function(event) {
      if (event.keyCode == 13) {
        event.preventDefault();
        ns.multi_items_dialog_update_result();
        return false;
      }
    });

    $('#multi_items_filter_all_substr_multi_ilike').focus();
  };

  ns.show_multi_items_dialog = function() {
    if (!ns.check_cv()) return;

    $('#row_table_id thead a img').remove();

    kivi.popup_dialog({
      url:    'controller.pl?action=Order/show_multi_items_dialog',
      data:   { type: $('#type').val() },
      id:     'jq_multi_items_dialog',
      load:   kivi.Order.setup_multi_items_dialog,
      dialog: {
        title:  kivi.t8('Add multiple items'),
        width:  800,
        height: 500
      }
    });
    return true;
  };

  ns.close_multi_items_dialog = function() {
    $('#jq_multi_items_dialog').dialog('close');
  };

  ns.multi_items_dialog_update_result = function() {
    var data = $('#multi_items_form').serializeArray();
    data.push({ name: 'type', value: $('#type').val() });
    $.ajax({
      url:     'controller.pl?action=Order/multi_items_update_result',
      data:    data,
      method:  'post',
      success: function(data) {
        $('#multi_items_result').html(data);
        ns.multi_items_dialog_enable_continue();
        ns.multi_items_result_setup_events();
      }
    });
  };

  ns.multi_items_dialog_disable_continue = function() {
    // disable keydown-event and continue button to prevent
    // impatient users to add parts multiple times
    $('#multi_items_result input').off("keydown");
    $('#multi_items_dialog_continue_button').prop('disabled', true);
  };

  ns.multi_items_dialog_enable_continue = function()  {
    $('#multi_items_result input').keydown(function(event) {
      if(event.keyCode == 13) {
        event.preventDefault();
        ns.add_multi_items();
        return false;
      }
    });
    $('#multi_items_dialog_continue_button').prop('disabled', false);
  };

  ns.multi_items_result_setup_events = function() {
    $('#multi_items_all_qty').change(ns.reformat_number);
    $('#multi_items_all_qty').change(function(event) {
      $('.multi_items_qty').val($(event.target).val());
    });
    $('.multi_items_qty').change(ns.reformat_number);
  }

  ns.add_multi_items = function() {
    // rows at all
    var n_rows = $('.multi_items_qty').length;
    if (n_rows == 0) return;

    // filled rows
    n_rows = $('.multi_items_qty').filter(function() {
      return $(this).val().length > 0;
    }).length;
    if (n_rows == 0) return;

    ns.multi_items_dialog_disable_continue();

    var data = $('#order_form').serializeArray();
    data = data.concat($('#multi_items_form').serializeArray());
    data.push({ name: 'action', value: 'Order/add_multi_items' });
    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.set_input_to_one = function(clicked) {
    if ($(clicked).val() == '') {
      $(clicked).val(kivi.format_amount(1.00, -2));
    }
    $(clicked).select();
  };

  ns.delete_order_item_row = function(clicked) {
    var row = $(clicked).parents("tbody").first();
    $(row).remove();

    ns.renumber_positions();
    ns.recalc_amounts_and_taxes();
  };

  ns.row_table_scroll_down = function() {
    $('#row_table_scroll_id').scrollTop($('#row_table_scroll_id')[0].scrollHeight);
  };

  ns.show_longdescription_dialog = function(clicked) {
    var row                 = $(clicked).parents("tbody").first();
    var position            = $(row).find('[name="position"]').html();
    var partnumber          = $(row).find('[name="partnumber"]').html();
    var description_elt     = $(row).find('[name="order.orderitems[].description"]');
    var description         = description_elt.val();
    var longdescription_elt = $(row).find('[name="order.orderitems[].longdescription"]');
    var longdescription;

    if (!longdescription_elt.length) {
      var data = [
        { name: 'action',   value: 'Order/get_item_longdescription'                          },
        { name: 'type',     value: $('#type').val()                                          },
        { name: 'item_id',  value: $(row).find('[name="order.orderitems[+].id"]').val()      },
        { name: 'parts_id', value: $(row).find('[name="order.orderitems[].parts_id"]').val() }
      ];

      $.ajax({
        url:      'controller.pl',
        data:     data,
        method:   "GET",
        async:    false,
        dataType: 'text',
        success:  function(val) {
          longdescription = val;
        }
      });
    } else {
      longdescription = longdescription_elt.val();
    }

    var params = {
      runningnumber:           position,
      partnumber:              partnumber,
      description:             description,
      default_longdescription: longdescription,
      set_function:            function(val) {
        longdescription_elt.remove();
        $('<input type="hidden" name="order.orderitems[].longdescription">').insertAfter(description_elt).val(val);
      }
    };

    kivi.SalesPurchase.edit_longdescription_with_params(params);
  };

  ns.price_chooser_item_row = function(clicked) {
    if (!ns.check_cv()) return;
    var row         = $(clicked).parents("tbody").first();
    var item_id_dom = $(row).find('[name="orderitem_ids[+]"]');

    var data = $('#order_form').serializeArray();
    data.push({ name: 'action',  value: 'Order/price_popup' },
              { name: 'item_id', value: item_id_dom.val()   });

    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.update_price_source = function(item_id, source, descr, price_str, price_editable) {
    var row        = $('#item_' + item_id).parents("tbody").first();
    var source_elt = $(row).find('[name="order.orderitems[].active_price_source"]');
    var button_elt = $(row).find('[name="price_chooser_button"]');

    button_elt.val(button_elt.val().replace(/.*\|/, descr + " |"));
    source_elt.val(source);

    var editable_div_elt     = $(row).find('[name="editable_price"]');
    var not_editable_div_elt = $(row).find('[name="not_editable_price"]');
    if (price_editable == 1 && source === '') {
      // editable
      $(editable_div_elt).show();
      $(not_editable_div_elt).hide();
      $(editable_div_elt).find(':input').prop("disabled", false);
      $(not_editable_div_elt).find(':input').prop("disabled", true);
    } else {
      // not editable
      $(editable_div_elt).hide();
      $(not_editable_div_elt).show();
      $(editable_div_elt).find(':input').prop("disabled", true);
      $(not_editable_div_elt).find(':input').prop("disabled", false);
    }

    if (price_str) {
      var price_elt = $(row).find('[name="order.orderitems[].sellprice_as_number"]');
      var html_elt  = $(row).find('[name="sellprice_text"]');
      price_elt.val(price_str);
      html_elt.html(price_str);
      ns.recalc_amounts_and_taxes();
    }

    kivi.io.close_dialog();
  };

  ns.update_discount_source = function(item_id, source, descr, discount_str, price_editable) {
    var row        = $('#item_' + item_id).parents("tbody").first();
    var source_elt = $(row).find('[name="order.orderitems[].active_discount_source"]');
    var button_elt = $(row).find('[name="price_chooser_button"]');

    button_elt.val(button_elt.val().replace(/\|.*/, "| " + descr));
    source_elt.val(source);

    var editable_div_elt     = $(row).find('[name="editable_discount"]');
    var not_editable_div_elt = $(row).find('[name="not_editable_discount"]');
    if (price_editable == 1 && source === '') {
      // editable
      $(editable_div_elt).show();
      $(not_editable_div_elt).hide();
      $(editable_div_elt).find(':input').prop("disabled", false);
      $(not_editable_div_elt).find(':input').prop("disabled", true);
    } else {
      // not editable
      $(editable_div_elt).hide();
      $(not_editable_div_elt).show();
      $(editable_div_elt).find(':input').prop("disabled", true);
      $(not_editable_div_elt).find(':input').prop("disabled", false);
    }

    if (discount_str) {
      var discount_elt = $(row).find('[name="order.orderitems[].discount_as_percent"]');
      var html_elt     = $(row).find('[name="discount_text"]');
      discount_elt.val(discount_str);
      html_elt.html(discount_str);
      ns.recalc_amounts_and_taxes();
    }

    kivi.io.close_dialog();
  };

  ns.show_periodic_invoices_config_dialog = function() {
    if ($('#type').val() !== 'sales_order') return;

    kivi.popup_dialog({
      url:    'controller.pl?action=Order/show_periodic_invoices_config_dialog',
      data:   { type:              $('#type').val(),
                id:                $('#id').val(),
                config:            $('#order_periodic_invoices_config').val(),
                customer_id:       $('#order_customer_id').val(),
                transdate_as_date: $('#order_transdate_as_date').val(),
                language_id:       $('#language_id').val()
              },
      id:     'jq_periodic_invoices_config_dialog',
      load:   kivi.reinit_widgets,
      dialog: {
        title:  kivi.t8('Edit the configuration for periodic invoices'),
        width:  800,
        height: 650
      }
    });
    return true;
  };

  ns.close_periodic_invoices_config_dialog = function() {
    $('#jq_periodic_invoices_config_dialog').dialog('close');
  };

  ns.assign_periodic_invoices_config = function() {
    var data = $('[name="Form"]').serializeArray();
    data.push({ name: 'type',   value: $('#type').val() },
              { name: 'action', value: 'Order/assign_periodic_invoices_config' });
    $.post("controller.pl", data, kivi.eval_json_result);
  };

  ns.check_save_active_periodic_invoices = function() {
    var type = $('#type').val();
    if (type !== 'sales_order') return true;

    var active = false;
    $.ajax({
      url:      'controller.pl',
      data:     { action: 'Order/get_has_active_periodic_invoices',
                  type  : type,
                  id    : $('#id').val(),
                  config: $('#order_periodic_invoices_config').val(),
                },
      method:   "GET",
      async:    false,
      dataType: 'text',
      success:  function(val) {
        active = val;
      }
    });

    if (active == 1) {
      return confirm(kivi.t8('This sales order has an active configuration for periodic invoices. If you save then all subsequently created invoices will contain those changes as well, but not those that have already been created. Do you want to continue?'));
    }

    return true;
  };

  ns.show_vc_details_dialog = function() {
    if (!ns.check_cv()) return;
    var vc;
    var vc_id;
    var title;
    if ($('#type').val() == 'sales_order' || $('#type').val() == 'sales_quotation' ) {
      vc    = 'customer';
      vc_id = $('#order_customer_id').val();
      title = kivi.t8('Customer details');
    } else {
      vc    = 'vendor';
      vc_id = $('#order_vendor_id').val();
      title = kivi.t8('Vendor details');
    }

    kivi.popup_dialog({
      url:    'controller.pl',
      data:   { action: 'Order/show_customer_vendor_details_dialog',
                type  : $('#type').val(),
                vc    : vc,
                vc_id : vc_id
              },
      id:     'jq_customer_vendor_details_dialog',
      dialog: {
        title:  title,
        width:  800,
        height: 650
      }
    });
    return true;
  };

  ns.show_calculate_qty_dialog = function(clicked) {
    var row        = $(clicked).parents("tbody").first();
    var input_id   = $(row).find('[name="order.orderitems[].qty_as_number"]').attr('id');
    var formula_id = $(row).find('[name="formula[+]"]').attr('id');

    calculate_qty_selection_dialog("", input_id, "", formula_id);
    return true;
  };

});

$(function() {
  if ($('#type').val() == 'sales_order' || $('#type').val() == 'sales_quotation' ) {
    $('#order_customer_id').change(kivi.Order.reload_cv_dependant_selections);
  } else {
    $('#order_vendor_id').change(kivi.Order.reload_cv_dependant_selections);
  }

  if ($('#type').val() == 'sales_order' || $('#type').val() == 'sales_quotation' ) {
    $('#add_item_parts_id').on('set_item:PartPicker', function(e,o) { $('#add_item_sellprice_as_number').val(kivi.format_amount(o.sellprice, -2)) });
  } else {
    $('#add_item_parts_id').on('set_item:PartPicker', function(e,o) { $('#add_item_sellprice_as_number').val(kivi.format_amount(o.lastcost, -2)) });
  }
  $('#add_item_parts_id').on('set_item:PartPicker', function(e,o) { $('#add_item_description').val(o.description) });
  $('#add_item_parts_id').on('set_item:PartPicker', function(e,o) { $('#add_item_unit').val(o.unit) });

  $('.add_item_input').keydown(function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
      kivi.Order.add_item();
      return false;
    }
  });

  kivi.Order.init_row_handlers();

  $('#row_table_id').on('sortstop', function(event, ui) {
    $('#row_table_id thead a img').remove();
    kivi.Order.renumber_positions();
  });

  $('#expand_all').on('click', function(event) {
    event.preventDefault();
    if ($('#expand_all').data('expanded') == 1) {
      $('#expand_all').data('expanded', 0);
      $('#expand_all').attr('src', 'image/expand.svg');
      $('#expand_all').attr('alt', kivi.t8('Show all details'));
      $('#expand_all').attr('title', kivi.t8('Show all details'));
      $('.row_entry').each(function(idx, elt) {
        kivi.Order.hide_second_row(elt);
      });
    } else {
      $('#expand_all').data('expanded', 1);
      $('#expand_all').attr('src', "image/collapse.svg");
      $('#expand_all').attr('alt', kivi.t8('Hide all details'));
      $('#expand_all').attr('title', kivi.t8('Hide all details'));
      kivi.Order.load_all_second_rows();
      $('.row_entry').each(function(idx, elt) {
        kivi.Order.show_second_row(elt);
      });
    }
    return false;
  });

});
