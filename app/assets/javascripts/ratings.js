$(function() {
	if ($"#pull_for_changes").length > 0 {
		setTimeout(updateRatings, 10000);
	}
});

function updateRatings () {
	$.getScript("/ratings.js?")
	setTimeout(updateRatings, 10000)
}