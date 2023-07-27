using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class BaseView extends Ui.View {
    hidden var _firstLoad;

    function initialize() {
        View.initialize();
        _firstLoad = true;
    }

    function onShow() {
        if (Hass.client.isLoggedIn()) {
            Hass.refreshAllEntities(true);
        }
    }

    // Load your resources here
    function onLayout(dc) {
        var scene = new Ui.Text({
            :text => "HassControl",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
        setLayout([scene]);
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        var entities = Hass.getEntities();

        var texts = new [entities.size()];
        for(var i = 0; i < entities.size(); i++) {
            var color = Graphics.COLOR_DK_GRAY;
            if (!entities[i].getRefreshing()) {
                color = Hass.Entity.stateToActive(entities[i].getState()) ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY;
            }

            var text = entities[i].getName();
            var sensorValue = entities[i].getSensorValue();
            if (sensorValue) {
                text += ": " + entities[i].getSensorValue();
            }

            texts[i] = new Ui.Text({
                :text => text,
                :color => color,
                :font => Graphics.FONT_SMALL,
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => (i + 1) * Graphics.getFontHeight(Graphics.FONT_SMALL)
            });
        }

        setLayout(texts);
    }
}
