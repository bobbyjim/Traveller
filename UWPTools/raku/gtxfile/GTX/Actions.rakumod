unit class GTX::Actions;

method TOP($/) {
    make $/<value>.made;
};

method hash($/) {
    make $/<pairlist>.made.hash.item;
}

method pairlist($/) {
    make $/<pair>>>.made.flat;
}

method pair($/) {
    make $/<string>.made => $<value>.made;
}

method string($/) {
    make $/<string>.made;
}