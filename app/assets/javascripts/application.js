// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


//
$(function () {
	$("#unwind_branches").click(function () {
		$(".hidden-moving-branches").toggle(100);
		if (this.getAttribute("data-unwinded") == "1") {
			$("#unwind_branches span").html("Show less branches");
			this.setAttribute("data-unwinded", "0");
		} else {
			$("#unwind_branches span").html("Show more branches");
			this.setAttribute("data-unwinded", "1");
		}
		return false;
	})

})
//Source index view,
//hide branch links
//ensure correct text on button to showing branches
$(document).ready(function () {
	$(".hidden-moving-branches").hide();
	$("#unwind_branches span").html("Show more branches");
});

$(document).ready(function () {

	$('a[href=\'#\']').click(function(e) {
		e.preventDefault();
	});

	if ($('#projectsList .deployment').length)
		$('#projectsList .deployment .failInfo a').click(function (e) {
			e.preventDefault();
			$(this).next().toggle(100);
		});

	if ($('table#highlitedCode div.highlight pre div.line').length) {

		$('table#highlitedCode div.highlight pre').selectable({
			filter:'div.line',
			stop:function (event, ui) {

				var prev = -1, startLine = -1, lines = 0;

				$('.ui-selected', this).each(function () {

					var index = $('table#highlitedCode div.highlight pre div.line').index(this);

					if (prev != -1 && prev + 1 != index) {
						$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
						return;
					}

					lines++;
					prev = index;
					if (startLine == -1)
						startLine = index + 1;
				});

				if ($('table#highlitedCode div.highlight pre div.line.ui-selected').length) {

					$('#comment_startLine').val(startLine);
					$('#comment_lines').val(lines);
					$('#newComment').dialog('open');
					$('#new_comment .errors').empty();
				}
			}
		});

		function initComments() {

			$('#comments .comment').unbind('click');

			var lines = new Array();

			$('#comments .comment').each(function () {

				for (var i = $(this).data('start-line'); i < $(this).data('start-line') + $(this).data('lines'); i++) {

					if (lines[i] == undefined)
						lines[i] = 0;

					lines[i]++;
				}
			});

			var lineWidth = $('table#highlitedCode div.highlight pre div.line').width() - 100,
				lineHeight = $('table#highlitedCode div.highlight pre div.line').outerHeight(),
				offsetLeft = 0, prevWidth = 0;

			$('#comments .comment').each(function () {

				var max = 1, startLine = $(this).data('start-line'), elines = $(this).data('lines');

				for (var i = startLine; i < startLine + elines; i++) {

					if (lines[i] != undefined && lines[i] > max)
						max = lines[i];
				}

				var newWidth = lineWidth / max - 4;

				if (newWidth != 0 && offsetLeft + prevWidth + newWidth < lineWidth)
					offsetLeft += prevWidth;
				else
					offsetLeft = 0;

				$(this).css({
					width:newWidth,
					top:1 + lineHeight * (startLine - 1),
					height:elines * lineHeight - 4,
					left:offsetLeft
				});

				prevWidth = newWidth + 4;
			});

			if ($('#showHideComments').html() == 'Show comments')
				$('#showHideComments').click();

			$('#comments .comment').click(function () {

				if ($('#deleteComment').length) {

					if ($('#deleteComment').data('origUrl') == undefined)
						$('#deleteComment').data('origUrl', $('#deleteComment').attr('href'));

					$('#deleteComment').attr('href', $('#deleteComment').data('origUrl').replace('_ID_', $(this).data('id')));
				}

				if ($('#new_comment_comment').data('origUrl') == undefined)
					$('#new_comment_comment').data('origUrl', $('#new_comment_comment').attr('action'));

				$('#new_comment_comment').attr('action', $('#new_comment_comment').data('origUrl').replace('_ID_', $(this).data('id')));

				$.get($('#commentDetails').data('comments').replace('_ID_', $(this).data('id')), function (data) {

					html = '';

					for (var i = 0; i < data.length; i++)
						html += '<div class="comment"><a href="/users/' + data[i].author.id + '"><b>' + data[i].author.name + '</b></a>: ' + data[i].commentText + '</div>';

					$('#commentDetails .comments').html(html);
				});

				$('#commentDetails > .comment').html($(this).html());
				$('#commentDetails .info').html('posted by <a href="' + $(this).data('author-url') + '">' + $(this).data('author') + '</a> on ' + $(this).data('posted'));
				$('#commentDetails').show();

				location.hash = '#comment_' + $(this).data('id')
			});
		}

		$('#new_comment').bind('ajax:beforeSend',function (evt, xhr, settings) {

			var $submitButton = $(this).find('input[name=commit]');

			if ($submitButton.val() == 'Submitting...')
				return;

			$submitButton.data('origText', $submitButton.val());
			$submitButton.val('Submitting...');
			$('#new_comment .errors').empty();
		}).bind('ajax:complete',function (evt, xhr, status) {

				var $submitButton = $(this).find('input[name=commit]');
				$submitButton.val($submitButton.data('origText'));
			}).bind('ajax:success',function (evt, data, status, xhr) {

				$('#new_comment .errors').empty();
				$('#comment_comment').val('');
				$('#newComment').dialog('close');

				var comment = $.parseJSON(xhr.responseText);
				var html = '<div class="comment" data-id="' + comment.id + '" data-start-line="' + comment.startLine + '" data-posted="' + comment.created_at + '" data-lines="' + comment.lines + '" data-author="' + comment.author.name + '" data-author-url="/users/' + comment.author.id + '">' + comment.comment + '</div>';

				var prev = null, broken = false;

				$('#comments .comment').each(function () {

					if ($(this).data('start-line') >= comment.startLine) {
						broken = true;
						return;
					}

					prev = $(this);
				});

				if (broken && prev != null)
					$(prev).after(html);
				else if (broken && prev == null)
					$('#comments > div').prepend(html);
				else
					$('#comments > div').append(html);

				initComments();
			}).bind('ajax:error', function (evt, xhr, status, error) {

				var errors, errorText;

				try {
					errors = $.parseJSON(xhr.responseText);
				} catch (err) {
					errors = {message:'Please reload the page and try again'};
				}

				errorText = 'There were errors with the submission: <ul>';

				for (error in errors)
					errorText += '<li>' + error + ': ' + errors[error] + '</li>';

				errorText += '</ul>';

				$('#new_comment .errors').html(errorText);
			});

		$('#new_comment_comment').bind('ajax:beforeSend',function (evt, xhr, settings) {

			var $submitButton = $(this).find('input[name=commit]');

			if ($submitButton.val() == 'Submitting...')
				return;

			$submitButton.data('origText', $submitButton.val());
			$submitButton.val('Submitting...');
			$('#new_comment_comment .errors').empty();
		}).bind('ajax:complete',function (evt, xhr, status) {

				var $submitButton = $(this).find('input[name=commit]');
				$submitButton.val($submitButton.data('origText'));
			}).bind('ajax:success',function (evt, data, status, xhr) {

				$('#new_comment_comment .errors').empty();
				$('#comment_comment_commentText').val('');

				var comment = $.parseJSON(xhr.responseText);
				var html = '<div class="comment"><a href="/users/' + comment.author.id + '"><b>' + comment.author.name + '</b></a>: ' + comment.commentText + '</div>';

				$('#commentDetails .comments').append(html);
			}).bind('ajax:error', function (evt, xhr, status, error) {

				var errors, errorText;

				try {
					errors = $.parseJSON(xhr.responseText);
				} catch (err) {
					errors = {message:'Please reload the page and try again'};
				}

				errorText = 'There were errors with the submission: <ul>';

				for (error in errors)
					errorText += '<li>' + error + ': ' + errors[error] + '</li>';

				errorText += '</ul>';

				$('#new_comment_comment .errors').html(errorText);
			});

		$(window).keydown(function (e) {
			if (e.keyCode == 17 || e.keyCode == 27)
				$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
		});

		$('#newComment').dialog({
			autoOpen:false,
			modal:true,
			width:600,
			resizable:false,
			draggable:false,
			beforeClose:function (event, ui) {
				$('table#highlitedCode div.highlight pre div.line').removeClass('ui-selected');
			}
		});

		$('#comments').css({
			top:$('#highlitedCode').position().top + 6,
			left:$('#highlitedCode div.highlight').position().left + 100
		});

		initComments();

		$('#commentDetails a#closeCommentBox').click(function (e) {
			e.preventDefault();
			$('#commentDetails').hide();
			location.hash = '';
		})

		$('#showHideComments').click(function (e) {
			e.preventDefault();

			if ($(this).html() == 'Hide comments') {
				$('#comments').hide();
				$(this).html('Show comments');
			} else {
				$('#comments').show();
				$(this).html('Hide comments');
			}
		});

		if (location.hash != '') {

			var parts = location.hash.split('_');

			if (parts[0] == '#comment')
				$('#comments .comment[data-id=' + parts[1] + ']').click();
		}
	}
});

var scrollLoading = false;
var page = 1;

function loadNextPage(element) {
	
	scrollLoading = true;
	
	$.get(location.href + '?page=' + (page+1), function(data) {
		
		if (data != '') {
			$(element).append(data);
			page++;
			scrollLoading = false;
		}
	}, 'html');
}
