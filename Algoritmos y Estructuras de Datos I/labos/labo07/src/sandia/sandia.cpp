bool sandia(int porciones) {
	if (porciones < 4) {
		return false;
	}

	if (porciones % 2 == 0) {
		return true;
	} else {
		return false;
	}
}
