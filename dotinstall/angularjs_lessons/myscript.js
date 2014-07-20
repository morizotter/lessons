var mainCtrl = function($scope) {
	$scope.users = [
		{"name":"morita", "score":53.22},
		{"name":"tanaka", "score":55.00},
		{"name":"satoru", "score":58.12}
	];
	$scope.today = new Date();
}

var userItemCtrl = function($scope) {
	$scope.increment = function() {
		$scope.user.score++;
	};
}