function filterBlocks() {
  jQuery('#block-store #block-types').slick('slickFilter', function() {
    var name = $(this).data('block-name');
    var filter = $('#block-store #block-store-filter').val();
    return name.toLowerCase().indexOf(filter.toLowerCase()) > -1;
  });
}

function cloneDraggableBlock(el, blockIcon) {
  el.addClass('ui-draggable-dragging');
  return blockIcon;
}

function startDragBlock() {
  $('#box-organizer').addClass('shadow');
}

function stopDragBlock() {
  $('#box-organizer').removeClass('shadow');
  $('.ui-draggable-dragging').removeClass('ui-draggable-dragging');
}

function initBlockStore() {
  var store = jQuery('#block-store #block-types').slick({
    infinite: false,
    dots: true,
    draggable: false,
    respondTo: 'slider',
    slidesToShow: 7,
    slidesToScroll: 6,
    responsive: [
      {
        breakpoint: 2048,
        settings: {
          slidesToShow: 10,
          slidesToScroll: 9,
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 8,
          slidesToScroll: 7,
        }
      }
    ]
  });
  jQuery('#block-store').show();
  jQuery('#block-store #block-store-filter').keyup(filterBlocks);
}
