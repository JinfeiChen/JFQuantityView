# JFQuantityView
电商项目中，添加购物车时，选择商品数量的视图控件。
代码太简单，一看即懂。


# Usage

    JFQuantity *productQuantityView = [[JFQuantityView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.productEditingContainer.frame)-padding-deleteButtonWidth, 30)];
    productQuantityView.min = 1;
    productQuantityView.max = 50;
    productQuantityView.delegate = self;
